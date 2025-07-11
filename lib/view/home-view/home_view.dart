import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:spotter/constants/colors.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:spotter/constant-widgets/constant_home_category.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
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
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(Get.width * 0.001),
            ),
          ),
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
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.02,
            horizontal: Get.width * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Report a crime and stay safe', style: kHead2Black),
              SizedBox(height: Get.height * 0.03),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: Get.width * 0.03,
                  mainAxisSpacing: Get.height * 0.015,
                ),
                children: [
                  ConstantHomeCategory(
                    text: 'Report A Crime',
                    icon: Icons.report,
                    onTap: () => Get.to(() => const RegistrationFormView()),
                  ),
                  ConstantHomeCategory(
                    text: 'Crime Prediction',
                    icon: Icons.online_prediction,
                    onTap: () => Get.to(() => const CrimePredictionView()),
                  ),
                  ConstantHomeCategory(
                    text: 'Emergency Services',
                    icon: Icons.call,
                    onTap: () => Get.to(() => const EmergencyServicesView()),
                  ),
                  ConstantHomeCategory(
                    text: 'Security Tips',
                    icon: Icons.article,
                    onTap: () => Get.to(() => const SecurityTipsView()),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.04),
              Text('Crime Reports by Users', style: kHead2Black),
              SizedBox(height: Get.height * 0.015),
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
                        final data = snapshot.data!.docs[index];
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
