// ignore: unused_import
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:spotter/constants/colors.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:spotter/view-model/auth_view_model.dart';
import 'package:spotter/view/home-view/about_us_view.dart';
import 'package:spotter/view/home-view/crime_prediction_view.dart';
import 'package:spotter/view/home-view/emergency_services_view.dart';
import 'package:spotter/view/home-view/registration-form/registration_form_view.dart';
import 'package:spotter/view/home-view/security_tips_view.dart';
import 'package:spotter/view/home-view/report_details_view.dart';
import 'package:spotter/notification_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();
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
    setState(() {
      _mapHtml = htmlContent;
    });
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
    final username = authViewModel.user?.displayName ?? 'User';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('SPOTTER', style: kHead1White),
          actions: [
            PopupMenuButton(
              color: constantColor,
              iconColor: kWhite,
              itemBuilder: (context) => [
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
        floatingActionButton: SpeedDial(
          icon: Icons.more_horiz, // main FAB icon
          backgroundColor: kPrimaryColor, // customizable color
          overlayOpacity: 0.2,
          spacing: 12,
          spaceBetweenChildren: 8,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add), // + icon for visual cue
              labelWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.black,
                  ), // extra + icon next to text
                  SizedBox(width: 4),
                  Text('Report A Crime', style: TextStyle(color: Colors.black)),
                ],
              ),
              onTap: () => Get.to(() => const RegistrationFormView()),
            ),
            SpeedDialChild(
              child: const Icon(Icons.online_prediction),
              label: 'Crime Prediction',
              onTap: () => Get.to(() => const CrimePredictionView()),
            ),
            SpeedDialChild(
              child: const Icon(Icons.call),
              label: 'Emergency Services',
              onTap: () => Get.to(() => const EmergencyServicesView()),
            ),
            SpeedDialChild(
              child: const Icon(Icons.article),
              label: 'Security Tips',
              onTap: () => Get.to(() => const SecurityTipsView()),
            ),
          ],
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
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 38, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Welcome, ',
                          style: TextStyle(color: Colors.black, fontSize: 28.0),
                        ),
                        TextSpan(
                          text: username,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text('Crime Hotspot Map', style: kHead2Black),
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
              Text('Crime Reports by Users', style: kHead2Black),
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
                        final data = reports[index];
                        final timestamp = (data['timestamp'] as Timestamp?)
                            ?.toDate();
                        final date = timestamp != null
                            ? '${timestamp.year}-${timestamp.month}-${timestamp.day}'
                            : 'Unknown Date';

                        return Card(
                          color: Colors.grey[100],
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(
                              '${data['crimeType']} at ${data['location']}',
                              style: kBody1Black,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Posted by: ${data['userEmail']}',
                                  style: kBody2Grey,
                                ),
                                Text(date, style: kBody2Grey),
                              ],
                            ),
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
                          ),
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
}
