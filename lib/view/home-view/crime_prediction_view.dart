import 'package:spotter/constant-widgets/constant_appbar.dart';
import 'package:spotter/constant-widgets/constant_button.dart';
import 'package:spotter/constant-widgets/constant_textfield.dart';
import 'package:spotter/constants/colors.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:spotter/view-model/crime_prediction_view_model.dart';
import 'package:spotter/view/home-view/crime_type_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class CrimePredictionView extends StatefulWidget {
  const CrimePredictionView({Key? key}) : super(key: key);

  @override
  State<CrimePredictionView> createState() => _CrimePredictionViewState();
}

class _CrimePredictionViewState extends State<CrimePredictionView> {
  TextEditingController dateController = TextEditingController();
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

  final ValueNotifier<String> selectedLocation = ValueNotifier<String>('');

  void showDate(context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 2),
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
  void dispose() {
    dateController.dispose();
    selectedLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CrimePredictionViewModel>(
      context,
      listen: true,
    );

    return SafeArea(
      child: Scaffold(
        appBar: const ConstantAppBar(text: 'Crime Prediction'),
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
                ConstantTextField(
                  controller: dateController,
                  onTapPrefixIcon: () => showDate(context),
                  hintText: 'Date (m/dd/yyyy)',
                  prefixIcon: Icons.date_range,
                ),
                SizedBox(height: Get.height * 0.02),
                SizedBox(
                  width: 200, // Adjust width as needed
                  height: 50, // Adjust height as needed
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedLocation.value.isEmpty ||
                          dateController.text.isEmpty) {
                        Get.snackbar(
                          colorText: kWhite,
                          'Message',
                          'Select location and date for prediction',
                          isDismissible: true,
                          dismissDirection: DismissDirection.startToEnd,
                        );
                      } else {
                        provider.getPrediction(
                          selectedLocation.value,
                          dateController.text.trim(),
                        );
                      }
                    },
                    child: const Text('Predict'),
                  ),
                ),
                SizedBox(height: Get.height * 0.08),
                selectedLocation.value.isNotEmpty ||
                        dateController.text.isNotEmpty
                    ? provider.isLoading
                          ? const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: SpinKitCircle(color: kBlack),
                            )
                          : PieChart(
                              dataMap: {
                                'Safe': 1 - provider.prediction,
                                'Crime': provider.prediction,
                              },
                              animationDuration: const Duration(seconds: 2),
                              chartLegendSpacing: 32,
                              chartRadius:
                                  MediaQuery.of(context).size.width / 2,
                              //    baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                              colorList: const [
                                Color(0xff4285f4), // Color for the 30%
                                Colors.red, // Transparent color for the 70%
                              ],
                              initialAngleInDegree: 0,
                              chartType: ChartType.disc,
                              ringStrokeWidth: 0, // Fill the entire circle
                              legendOptions: LegendOptions(
                                showLegendsInRow: false,
                                legendPosition: LegendPosition.right,
                                // ignore: unnecessary_null_comparison
                                showLegends: provider.prediction != null
                                    ? true
                                    : false, // Hide the legend
                                legendShape: BoxShape.circle,
                                legendTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: true,
                                showChartValuesOutside: false,
                                decimalPlaces: 4,
                              ),
                              totalValue: 1,
                            )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: ConstantButton(
            buttonText: 'Search With Type',
            onTap: () => Get.to(() => const CrimeTypeView()),
          ),
        ),
      ),
    );
  }
}
