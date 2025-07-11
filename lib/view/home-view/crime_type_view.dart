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
    'khanna',
    'koral',
    'kirpa',
    'humak',
    'lohi bher',
    'pliugran',
    'barakahu',
    'shehzad town',
    'bani gala',
    'nilore',
    'sihala',
    'g-6',
    'g-7',
    'g-8',
    'g-9',
    'g-10',
    'g-11',
    'g-12',
    'g-13',
    'g-14',
    'g-16',
    'f-6',
    'f-7',
    'f-8',
    'f-9',
    'f-10',
    'f-11',
    'f-12',
    'f-13',
    'f-17',
    'e-7',
    'e-8',
    'e-9',
    'e-16',
    'd-12',
    'd-16',
    'd-17',
    'i-8',
    'i-9',
    'i-10',
    'i-11',
    'i-14',
    'i-15',
    'i-16',
    'c-15',
    'c-16',
    'c-17',
    'h-8',
    'h-9',
    'h-10',
    'h-11',
    'h-12',
    'h-13',
    'b-17',
  ];
  List<String> category = [
    'domestic violence(spousal abuse)',
    'domestic violence(child abuse)',
    'traffic violations(hit and run)',
    'kidnapping',
    'robbery(property)',
    'robbery(car)',
    'robbery(motorcycle)',
    'robbery(cash)',
    'attempt murder',
    'murder',
    'snatching',
    'rape',
    'harrasment',
    'assault',
    'drug trafficking',
    'drug possession',
    'honor killing',
    'burglary',
    'fraud',
    'reckless driving',
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
