import 'package:spotter/constant-widgets/constant_appbar.dart';
import 'package:spotter/constant-widgets/constant_button.dart';
import 'package:spotter/constant-widgets/constant_textfield.dart';
import 'package:spotter/constants/colors.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:spotter/view-model/report_view_model.dart';
import 'package:spotter/constant-widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationFormView extends StatefulWidget {
  const RegistrationFormView({super.key});

  @override
  State<RegistrationFormView> createState() => _RegistrationFormViewState();
}

class _RegistrationFormViewState extends State<RegistrationFormView> {
  final List<String> location = [
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

  final List<String> time = [
    'morning (06:00 - 11:59)',
    'afternoon (12:00 - 16:59)',
    'evening (17:00 - 20:59)',
    'night (21:00 - 05:59)',
  ];

  final List<String> category = [
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
  final ValueNotifier<String> selectedTime = ValueNotifier<String>('');
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void showDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      dateController.text = DateFormat('M/dd/yyyy').format(picked);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    cnicController.dispose();
    selectedLocation.dispose();
    selectedCategory.dispose();
    dateController.dispose();
    selectedTime.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: const ConstantAppBar(text: 'Report Crime'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ConstantTextField(
                  controller: nameController,
                  hintText: 'Enter your name',
                  prefixIcon: Icons.person,
                ),
                SizedBox(height: 12.h),
                ConstantTextField(
                  controller: cnicController,
                  hintText: 'ID Number',
                  prefixIcon: Icons.numbers,
                ),
                SizedBox(height: 12.h),
                ConstantTextField(
                  controller: dateController,
                  onTapPrefixIcon: () => showDate(context),
                  hintText: 'Crime Date (m/dd/yyyy)',
                  prefixIcon: Icons.date_range,
                ),
                SizedBox(height: 12.h),
                _buildDropdown(
                  'Crime Incident Time',
                  selectedTime,
                  time,
                  Icons.access_time,
                ),
                SizedBox(height: 12.h),
                _buildDropdown(
                  'Location',
                  selectedLocation,
                  location,
                  Icons.location_on,
                ),
                SizedBox(height: 12.h),
                _buildDropdown(
                  'Category',
                  selectedCategory,
                  category,
                  Icons.category,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: descriptionController,
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: kBody1Black,
                  decoration: InputDecoration(
                    hintText: 'Describe what you witnessed...',
                    hintStyle: kBody2Black,
                    fillColor: const Color(0xFFF0E6FF),
                    filled: true,
                    contentPadding: EdgeInsets.all(16.r),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: ConstantButton(
            buttonText: 'Submit Data',
            onTap: () async {
              if (_allFieldsValid()) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await provider.addCrimeReport(
                    crimeType: selectedCategory.value,
                    location: selectedLocation.value,
                    timeOfCrime: selectedTime.value,
                    date: dateController.text.trim(),
                    description: descriptionController.text.trim(),
                    name: nameController.text.trim(),
                    cnic: cnicController.text.trim(),
                    category: selectedCategory.value,
                    time: selectedTime.value,
                  );
                  _clearFields();
                  _showSuccessDialog(context);
                } else {
                  Fluttertoast.showToast(msg: 'User not authenticated');
                }
              } else {
                Fluttertoast.showToast(msg: 'Please enter all details');
              }
            },
          ),
        ),
      ),
    );
  }

  bool _allFieldsValid() {
    return nameController.text.isNotEmpty &&
        cnicController.text.isNotEmpty &&
        selectedLocation.value.isNotEmpty &&
        dateController.text.isNotEmpty &&
        selectedTime.value.isNotEmpty &&
        selectedCategory.value.isNotEmpty &&
        descriptionController.text.isNotEmpty;
  }

  void _clearFields() {
    nameController.clear();
    cnicController.clear();
    dateController.clear();
    descriptionController.clear();
    selectedLocation.value = '';
    selectedTime.value = '';
    selectedCategory.value = '';
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Crime report successfully submitted.'),
        actions: [
          TextButton(
            onPressed: () =>
                Get.offAll(() => const BottomNavigationBarWidget()),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    ValueNotifier<String> selectedValue,
    List<String> options,
    IconData icon,
  ) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedValue,
      builder: (_, value, __) {
        return DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0E6FF),
            prefixIcon: Icon(icon, color: kBlack),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide.none,
            ),
          ),
          hint: Text(hint, style: kBody2Black),
          items: options.map((opt) {
            return DropdownMenuItem<String>(
              value: opt,
              child: FittedBox(child: Text(opt, style: kBody1Black)),
            );
          }).toList(),
          onChanged: (val) => selectedValue.value = val ?? '',
        );
      },
    );
  }
}
