import 'package:spotter/constant-widgets/constant_appbar.dart';
import 'package:spotter/constants/colors.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:spotter/view-model/crime_rate_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CrimeRateView extends StatelessWidget {
  const CrimeRateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CrimeRateViewModel>(context);
    return SafeArea(
      child: Scaffold(
        appBar: const ConstantAppBar(text: 'Top 5 Crime Areas'),
        body: FutureBuilder(
          future: provider.getTopCrimes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: SpinKitCircle(color: kBlack));
            }
            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!['data'] == null ||
                snapshot.data!['data']['items'] == null) {
              return Center(child: Text('No Crimes', style: kBody1Black));
            }

            List<dynamic> items = snapshot.data!['data']['items'];

            List<CrimeData> crimesData = items.map((item) {
              return CrimeData(
                item['crime_location'] ?? '',
                int.tryParse(item['count'].toString()) ?? 0,
              );
            }).toList();

            return Center(
              child: SizedBox(
                height: Get.height * 0.7,
                child: SfCircularChart(
                  series: <CircularSeries>[
                    PieSeries<CrimeData, String>(
                      dataSource: crimesData,
                      xValueMapper: (CrimeData crime, _) => crime.location,
                      yValueMapper: (CrimeData crime, _) => crime.count,
                      dataLabelMapper: (CrimeData crime, _) =>
                          '${crime.location}: ${crime.count}',
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CrimeData {
  final String location;
  final int count;

  CrimeData(this.location, this.count);
}
