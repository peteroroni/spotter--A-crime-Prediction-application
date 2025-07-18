import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotter/constant-widgets/bottom_nav_bar.dart';
import 'package:spotter/constants/textstyles.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 96, 125, 139),

          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 250, 248, 248),
            ),
            onPressed: () => Get.offAll(() => BottomNavigationBarWidget()),
          ),
          centerTitle: true,
          title: const Text(
            'About SPOTTER',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 248, 250, 250),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * 0.02),
                Text(
                  'Welcome to the SPOTTER - Your Trusted Partner in Community Safety!',
                  style: kBody1Transparent,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Get.height * 0.02),
                Text(
                  'Our Mission',
                  style: kHead3Black,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Empowering communities with safety tools and fostering security. We believe that proactive measures, informed decisions, and a united community are fundamental elements in creating safer living environments.',
                  style: kBody2Black,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Get.height * 0.03),
                Text(
                  'What Sets Us Apart',
                  style: kHead3Black,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Get.height * 0.02),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1. Innovative Crime Hotspot Prediction:',
                        style: kHead3Black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          '• Stands at the forefront of innovation with our cutting-edge technology. We leverage predictive analytics and machine learning to identify potential crime hotspots, providing users with valuable insights.',
                          style: kBody2Black,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.01),
                      Text('2. User-Centric Approach:', style: kHead3Black),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          '• Designed with the end user in mind, ensuring a seamless experience. We prioritize user feedback and continuously enhance the functionality and usability of our app.',
                          style: kBody2Black,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.01),
                      Text('3. Community Empowerment:', style: kHead3Black),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          '• Encourages community members to actively participate in safety initiatives, share information, and work together to create secure neighborhoods.',
                          style: kBody2Black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.05),
                Center(
                  child: Text(
                    'Developed by the SPOTTER Team',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                SizedBox(height: Get.height * 0.05),
                Center(
                  child: Text(
                    '© 2025 SPOTTER',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
