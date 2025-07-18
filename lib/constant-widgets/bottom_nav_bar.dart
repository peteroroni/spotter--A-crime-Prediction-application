import 'package:flutter_svg/flutter_svg.dart';

import 'package:spotter/constants/colors.dart';
import 'package:spotter/view/crime-rate/crime_rate_view.dart';
import 'package:spotter/view/home-view/home_view.dart';
import 'package:spotter/view/home-view/crime_prediction_view.dart';
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
    const CrimePredictionPage(),
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
            // type: BottomNavigationBarType.shifting,
            onTap: (index) {
              setState(() {
                isSelectedTab = index;
              });
            },
            selectedItemColor: Colors.black,
            unselectedItemColor: kWhite,
            backgroundColor: Colors.blueGrey,
            items: [
              BottomNavigationBarItem(
                icon: DecoratedIcon(
                  icon: Icon(
                    Icons.home,
                    size: 26.r,
                    //    color: kWhite,
                  ),
                  decoration: IconDecoration(
                    // border: IconBorder(color: kBlack, width: 2.w),
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: DecoratedIcon(
                  icon: Icon(
                    Icons.insert_chart,
                    size: 26.r,
                    //   color: kWhite,
                  ),
                  decoration: IconDecoration(
                    // border: IconBorder(color: kBlack, width: 2.w),
                  ),
                ),
                label: 'Statistics',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(4.w),
                  //decoration: BoxDecoration(
                  //border: Border.all(color: kBlack, width: 2.w),
                  //shape: BoxShape.circle, // Optional: circle border
                  //),
                  child: SvgPicture.asset(
                    'assets/images/prediction.svg',
                    width: 26.r,
                    height: 26.r,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                label: 'Predictions',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
