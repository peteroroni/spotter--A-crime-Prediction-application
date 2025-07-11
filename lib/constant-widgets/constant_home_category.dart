import 'package:spotter/constants/colors.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConstantHomeCategory extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const ConstantHomeCategory({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: constantColor,
          borderRadius: BorderRadius.circular(Get.width * 0.02),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 30.r),
              Text(text, style: kHead2Black, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
