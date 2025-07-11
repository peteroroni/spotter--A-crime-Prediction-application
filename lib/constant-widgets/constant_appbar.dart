import 'package:spotter/constants/colors.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:spotter/constant-widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConstantAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const ConstantAppBar({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      centerTitle: true,
      title: Text(text, style: kHead2White),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(Get.width * 0.005),
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Color.fromARGB(255, 250, 248, 248),
        ),
        onPressed: () => Get.offAll(() => const BottomNavigationBarWidget()),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Get.height * 0.08);
}
