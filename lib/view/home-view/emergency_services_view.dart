import 'package:spotter/constant-widgets/bottom_nav_bar.dart';
// ignore: unused_import
import 'package:spotter/constant-widgets/constant_appbar.dart'; //this import is not used in the current file but may be needed for future use
import 'package:spotter/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: unused_import
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyServicesView extends StatelessWidget {
  const EmergencyServicesView({super.key});

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
            'Emergency Services',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 248, 250, 250),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmergencyServiceCard(
                imagePath: 'assets/images/police.jpeg',
                serviceName: 'Police',
                number: '112',
                description:
                    'For reporting crime or requesting urgent police intervention.',
              ),
              SizedBox(height: 20.h),
              EmergencyServiceCard(
                imagePath: 'assets/images/ambulance.jpeg',
                serviceName: 'Ambulance',
                number: '112',
                description: 'For medical emergencies and paramedic dispatch.',
              ),
              SizedBox(height: 20.h),
              EmergencyServiceCard(
                imagePath: 'assets/images/firebrigade.jpeg',
                serviceName: 'Fire Brigade',
                number: '4214',
                description:
                    'For fire emergencies, rescue, and disaster response.',
              ),
              SizedBox(height: 32.h),
              Text('Others', style: kHead3Black),
              SizedBox(height: 12.h),
              EmergencyServiceCard(
                serviceName: 'AAR Emergency',
                number: '0703 063 000',
                description: 'Private ambulance and emergency services.',
              ),
              SizedBox(height: 20.h),
              EmergencyServiceCard(
                serviceName: 'St. John Ambulance',
                number: '0721 611 555',
                description: 'Ambulance and first aid response services.',
              ),
              SizedBox(height: 20.h),
              EmergencyServiceCard(
                serviceName: 'Kenya Red Cross',
                number: '0700 395 395',
                description: 'Emergency and disaster response.',
              ),
              SizedBox(height: 20.h),
              EmergencyServiceCard(
                serviceName: 'Nairobi City Fire Department',
                number: '020 222 2181',
                description: 'City fire response and rescue services.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmergencyServiceCard extends StatelessWidget {
  final String? imagePath;
  final String serviceName;
  final String number;
  final String description;

  const EmergencyServiceCard({
    super.key,
    this.imagePath,
    required this.serviceName,
    required this.number,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.asset(
                    imagePath!,
                    height: 60.h,
                    width: 60.h,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  height: 60.h,
                  width: 60.h,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    getInitials(serviceName),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Colors.blue.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bulletText(serviceName, bold: true),
                bulletText(description),
                SizedBox(height: 6.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: () => dialNumber(number),
                    child: Text(
                      'Call',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bulletText(String text, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: bold
                  ? kBody3Black.copyWith(fontWeight: FontWeight.bold)
                  : kBody3Black,
            ),
          ),
        ],
      ),
    );
  }

  String getInitials(String name) {
    final words = name.split(' ');
    if (words.length == 1) return words[0].substring(0, 2).toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }
}

Future<void> dialNumber(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(launchUri);
}
