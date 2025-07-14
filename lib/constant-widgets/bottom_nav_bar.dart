import 'package:spotter/constants/colors.dart';
import 'package:spotter/view/crime-rate/crime_rate_view.dart';
import 'package:spotter/view/home-view/home_view.dart';
import 'package:spotter/view/profile-view/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:icon_decoration/icon_decoration.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int isSelectedTab = 0;

  List<Widget> pages = [
    const HomeView(),
    const CrimeRateView(),
    const UserProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isSelectedTab != 0) {
          setState(() {
            isSelectedTab = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: pages[isSelectedTab],
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Get.width * 0.04),
            topRight: Radius.circular(Get.width * 0.04),
          ),
          child: BottomNavigationBar(
            currentIndex: isSelectedTab,
            //   type: BottomNavigationBarType.shifting,
            onTap: (index) {
              setState(() {
                isSelectedTab = index;
              });
            },
            selectedItemColor: Colors.teal,
            unselectedItemColor: kWhite,
            backgroundColor: kPrimaryColor,
            items: [
              BottomNavigationBarItem(
                icon: DecoratedIcon(
                  icon: Icon(
                    Icons.home,
                    size: 26.r,
                    //    color: kWhite,
                  ),
                  decoration: IconDecoration(
                    border: IconBorder(color: kBlack, width: 2.w),
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: DecoratedIcon(
                  icon: Icon(
                    Icons.pie_chart_outline_outlined,
                    size: 26.r,
                    //   color: kWhite,
                  ),
                  decoration: IconDecoration(
                    border: IconBorder(color: kBlack, width: 2.w),
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: DecoratedIcon(
                  icon: Icon(
                    Icons.person_pin,
                    size: 26.r,
                    //   color: kWhite,
                  ),
                  decoration: IconDecoration(
                    border: IconBorder(color: kBlack, width: 2.w),
                  ),
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
