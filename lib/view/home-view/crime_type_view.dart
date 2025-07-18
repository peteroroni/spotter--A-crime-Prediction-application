// this file may not be needed afterall

import 'package:spotter/constant-widgets/constant_appbar.dart';
import 'package:spotter/constant-widgets/constant_textfield.dart';
import 'package:spotter/constants/colors.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:spotter/view-model/crime_type_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CrimeTypeView extends StatefulWidget {
  const CrimeTypeView({super.key});

  @override
  State<CrimeTypeView> createState() => _CrimeTypeViewState();
}

class _CrimeTypeViewState extends State<CrimeTypeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimationLeftToRight;
  late Animation<Offset> _slideAnimationBottomToTop;
  late Animation<double> _fadeAnimation;

  List<String> location = [
    'Cherry Park',
    'Gachororo',
    'Gate B',
    'Gate C',
    'JKUAT hostels area',
    'Highpoint',
    'JKUAT Enterprises LTD.',
    'JKUAT Hospital',
    'JKUAT Main Gate',
    'JKUAT SAJOREC Botanical Garden',
    'Juja City Mall',
    'Juja Market',
    'Juja Police Station',
    'Juja Square',
    'Juja Stage',
  ];
  List<String> category = [
    'assault',
    'armed robbery',
    'battery',
    'burglary',
    'domestic violence',
    'drug possession',
    'drug trafficking',
    'fraud',
    'kidnapping',
    'murder',
    'phone snatching',
    'reckless driving',
    'robbery',
    'sexual harrasment',
    'traffic violations',
  ];
  final ValueNotifier<String> selectedLocation = ValueNotifier<String>('');
  final ValueNotifier<String> selectedCategory = ValueNotifier<String>('');
  TextEditingController dateController = TextEditingController();
  double coloredPercentage = 30; // Initial value for the colored percentage

  void showDate(context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1),
      lastDate: DateTime(2050, 12),
      builder: (context, picker) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.green[900],
          ),
          child: picker!,
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        final formattedDate = DateFormat('M/dd/yyyy').format(selectedDate);
        dateController.text = formattedDate;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimationLeftToRight = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _slideAnimationBottomToTop = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    dateController.dispose();
    selectedLocation.dispose();
    selectedCategory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CrimeTypeViewModel>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        appBar: const ConstantAppBar(text: 'Search With Category'),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.1,
            vertical: Get.height * 0.02,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: selectedLocation,
                  builder: (context, value, child) {
                    return DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFFF0E6FF),
                      hint: Text('Location', style: kBody2Black),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 28.r,
                        color: kBlack,
                      ),
                      isExpanded: true,
                      decoration: InputDecoration(
                        fillColor: const Color(0xFFF0E6FF),
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.location_pin,
                          color: kBlack,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.w),
                          borderRadius: BorderRadius.circular(Get.width * 0.1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.w),
                          borderRadius: BorderRadius.circular(Get.width * 0.1),
                        ),
                      ),
                      value: value.isEmpty ? null : value,
                      items: location.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(value, style: kBody1Black),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        selectedLocation.value = value ?? '';
                      },
                    );
                  },
                ),
                SizedBox(height: Get.height * 0.02),
                ValueListenableBuilder(
                  valueListenable: selectedCategory,
                  builder: (context, value, child) {
                    return DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFFF0E6FF),
                      hint: Text('Category', style: kBody2Black),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 28.r,
                        color: kBlack,
                      ),
                      isExpanded: true,
                      decoration: InputDecoration(
                        fillColor: const Color(0xFFF0E6FF),
                        filled: true,
                        prefixIcon: const Icon(Icons.category, color: kBlack),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.w),
                          borderRadius: BorderRadius.circular(Get.width * 0.1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.w),
                          borderRadius: BorderRadius.circular(Get.width * 0.1),
                        ),
                      ),
                      value: value.isEmpty ? null : value,
                      items: category.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(value, style: kBody1Black),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        selectedCategory.value = value ?? '';
                      },
                    );
                  },
                ),
                SizedBox(height: Get.height * 0.02),
                ConstantTextField(
                  controller: dateController,
                  onTapPrefixIcon: () => showDate(context),
                  hintText: 'Date (m/dd/yyyy)',
                  prefixIcon: Icons.date_range,
                ),
                SizedBox(height: Get.height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    if (selectedLocation.value.isEmpty ||
                        selectedCategory.value.isEmpty ||
                        dateController.text.isEmpty) {
                      Get.snackbar(
                        'Message',
                        'Select all fields',
                        colorText: kWhite,
                        isDismissible: true,
                        dismissDirection: DismissDirection.startToEnd,
                      );
                    } else {
                      provider
                          .getSearchCrimes(
                            selectedLocation.value,
                            selectedCategory.value,
                            dateController.text.trim(),
                          )
                          .then((value) {
                            _controller.reset();
                            _controller.forward();
                          });
                    }
                  },
                  child: const Text('Search'),
                ),
                SizedBox(height: Get.height * 0.05),
                provider.isLoading
                    ? const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: SpinKitCircle(color: kBlack),
                      )
                    : Column(
                        children: [
                          SlideTransition(
                            position: _slideAnimationLeftToRight,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Number of ',
                                      style: kBody1Black,
                                    ),
                                    TextSpan(
                                      text: selectedCategory.value,
                                      style: kBody1Transparent,
                                    ),
                                    TextSpan(text: ' in ', style: kBody1Black),
                                    TextSpan(
                                      text: '${selectedLocation.value}:',
                                      style: kBody1Transparent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SlideTransition(
                            position: _slideAnimationBottomToTop,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                padding: EdgeInsets.all(15.r),
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  provider.count.toString(),
                                  style: kHead2White,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
