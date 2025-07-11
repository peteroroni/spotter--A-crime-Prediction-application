import 'package:spotter/constants/colors.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConstantTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onTapSuffixIcon;
  final VoidCallback? onTapPrefixIcon;
  final bool? obscureText;
  const ConstantTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.onTapSuffixIcon,
    this.onTapPrefixIcon,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: hintText == 'Email'
          ? TextInputType.emailAddress
          : hintText == 'CNIC'
          ? TextInputType.number
          : TextInputType.text,
      decoration: InputDecoration(
        fillColor: constantColor,
        filled: true,
        prefixIcon: InkWell(
          onTap: onTapPrefixIcon,
          child: Icon(prefixIcon, color: kBlack),
        ),
        suffixIcon: InkWell(
          onTap: onTapSuffixIcon,
          child: Icon(suffixIcon, color: kBlack),
        ),
        hintText: hintText,
        hintStyle: kBody2Black,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Get.width * 0.1),
          borderSide: BorderSide.none,
        ),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Get.width * 0.1),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
