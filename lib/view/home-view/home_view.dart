// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

import 'package:spotter/constants/colors.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:spotter/view-model/auth_view_model.dart';
import 'package:spotter/view/home-view/about_us_view.dart';
import 'package:spotter/view/home-view/crime_prediction_view.dart';
import 'package:spotter/view/home-view/emergency_services_view.dart';
import 'package:spotter/view/home-view/registration-form/registration_form_view.dart';
import 'package:spotter/view/profile-view/user_profile_view.dart';
// ignore: duplicate_import
import 'package:spotter/view/home-view/crime_prediction_view.dart';
import 'package:spotter/view/home-view/security_tips_view.dart';
import 'package:spotter/view/home-view/report_details_view.dart';
import 'package:spotter/notification_service.dart';
import 'package:spotter/database/user_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();
  final UserController userController = Get.put(UserController());
  // ignore: unused_field
  late WebViewController _webViewController;
  String _mapHtml = "";

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadMapHtml();
  }

  Future<void> _loadMapHtml() async {
    final htmlContent = await rootBundle.loadString(
      'assets/images/crime_clusters_map.html',
    );
    setState(() => _mapHtml = htmlContent);
  }

  void _initializeNotifications() {
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });

    _localNotificationService.requestNotificationPermission();
    _localNotificationService.forgroundMessage();
    _localNotificationService.firebaseInit(context);
    _localNotificationService.setupInteractMessage(context);
    _localNotificationService.isTokenRefresh();
    FirebaseMessaging.instance.subscribeToTopic('all');
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('SPOTTER', style: kHead1White),
          actions: [
            PopupMenuButton(
              color: constantColor,
              iconColor: kWhite,
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => Get.to(() => const UserProfileView()),
                  child: Text('Edit Profile', style: kBody1Black),
                ),
                PopupMenuItem(
                  onTap: () => Get.to(() => const AboutUsView()),
                  child: Text('About Us', style: kBody1Black),
                ),
                PopupMenuItem(
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Are you sure to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                                authViewModel.signOut();
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('No'),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                  child: Text('Logout', style: kBody1Black),
                ),
              ],
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blueGrey,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Report A Crime",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Get.to(() => const RegistrationFormView()),
        ),

        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.02,
            horizontal: Get.width * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () {
                        Get.to(() => UserProfileView());
                      },
                      child: const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blueGrey,
                        child: Icon(
                          Icons.person,
                          size: 38,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Obx(
                    () => Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Welcome, ',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 28.0,
                            ),
                          ),
                          TextSpan(
                            text: userController.username.value,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Crime Hotspot Map',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 14),
              _mapHtml.isNotEmpty
                  ? SizedBox(
                      height: Get.height * 0.3,
                      child: WebViewWidget(
                        controller: WebViewController()
                          ..setJavaScriptMode(JavaScriptMode.unrestricted)
                          ..loadHtmlString(_mapHtml),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () =>
                          Get.to(() => const EmergencyServicesView()),
                      child: const Text(
                        'Emergency Services',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Get.to(() => const SecurityTipsView()),
                      child: const Text(
                        'Security Tips',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Crime Reports by Users',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Posts')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No reports available'));
                    }

                    final reports = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final doc = reports[index];
                        final data = doc.data() as Map<String, dynamic>;

                        final Timestamp? ts = data['timestamp'] as Timestamp?;
                        final DateTime? dateTime = ts?.toDate();
                        final String date = dateTime != null
                            ? DateFormat('MMM d, yyyy').format(
                                dateTime,
                              ) // e.g., Jul 17, 2025
                            : 'Unknown Date';

                        return buildCustomReportTile(
                          data: data,
                          date: date,
                          titleFontSize: 16,
                          subtitleFontSize: 13,
                          iconSize: 20,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomReportTile({
    required Map<String, dynamic> data,
    required String date,
    double titleFontSize = 14,
    double subtitleFontSize = 12,
    double iconSize = 16,
  }) {
    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: InkWell(
          onTap: () => Get.to(
            () => ReportDetailsView(
              category: data['crimeType'],
              date: date,
              place: data['location'],
              time: data['timeOfCrime'],
              description: data['description'],
              email: data['userEmail'],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${data['crimeType']} ',
                            style: kBody1Black.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: titleFontSize,
                            ),
                          ),
                          TextSpan(
                            text: 'at ${data['location']}',
                            style: kBody1Black.copyWith(
                              fontSize: titleFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Posted by: ${data['userEmail']}',
                      style: kBody2Grey.copyWith(fontSize: subtitleFontSize),
                    ),
                    Text(
                      date,
                      style: kBody2Grey.copyWith(fontSize: subtitleFontSize),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.arrow_forward_ios, size: iconSize),
            ],
          ),
        ),
      ),
    );
  }
}
