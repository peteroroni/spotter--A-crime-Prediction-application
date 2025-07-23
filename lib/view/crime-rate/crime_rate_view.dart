// ignore_for_file: unused_import, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spotter/constant-widgets/bottom_nav_bar.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:spotter/constant-widgets/constant_appbar.dart';
import 'package:spotter/view-model/crime_rate_view_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class CrimeRateView extends StatefulWidget {
  const CrimeRateView({Key? key}) : super(key: key);

  @override
  State<CrimeRateView> createState() => _CrimeRateViewState();
}

class _CrimeRateViewState extends State<CrimeRateView> {
  DateTimeRange? _selectedDateRange;
  String? _selectedLocation;
  List<Map<String, dynamic>> _cachedReports = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 96, 125, 139),
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.offAll(() => BottomNavigationBarWidget()),
          ),
          centerTitle: true,
          title: const Text(
            'Dashboard & Statistics',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: () => _generatePdf(includeFull: true),
              label: const Text("Download Full PDF"),
              icon: const Icon(Icons.picture_as_pdf),
            ),
            const SizedBox(height: 10),
            FloatingActionButton.extended(
              onPressed: () => _generatePdf(includeFull: false),
              label: const Text("Top Stats Only"),
              icon: const Icon(Icons.download),
            ),
          ],
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _loadAllReports(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());

            _cachedReports = snapshot.data!;
            final filteredReports = _filterReports(_cachedReports);
            final now = DateTime.now();
            int daily = 0, weekly = 0, monthly = 0;
            Map<String, int> crimeTypes = {};
            Map<String, int> locations = {};
            Map<String, int> timeSeries = {};

            for (var report in filteredReports) {
              final dateStr = report['date'];
              final type =
                  report['crime_type'] ?? report['crimeType'] ?? 'Unknown';
              final location = report['location'] ?? 'Unknown';
              final ts = DateTime.tryParse(dateStr.toString());
              if (ts == null) continue;

              final key = "${ts.year}-${ts.month.toString().padLeft(2, '0')}";

              if (ts.day == now.day &&
                  ts.month == now.month &&
                  ts.year == now.year)
                daily++;
              if (now.difference(ts).inDays <= 7) weekly++;
              if (now.month == ts.month && now.year == ts.year) monthly++;

              crimeTypes[type] = (crimeTypes[type] ?? 0) + 1;
              locations[location] = (locations[location] ?? 0) + 1;
              timeSeries[key] = (timeSeries[key] ?? 0) + 1;
            }

            final mostCommonCrime = crimeTypes.isNotEmpty
                ? crimeTypes.entries.reduce((a, b) => a.value > b.value ? a : b)
                : const MapEntry("N/A", 0);

            final avgPerDay = (filteredReports.length / 30).toStringAsFixed(1);
            final avgPerWeek = (filteredReports.length / 7).toStringAsFixed(1);
            final avgPerMonth = (filteredReports.length / 1).toStringAsFixed(0);

            final topCrimeTypes = _topEntries(crimeTypes);
            final topLocations = _topEntries(locations);
            final allLocations = locations.keys.toSet().toList()..sort();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilters(context, allLocations),
                  const SizedBox(height: 20),
                  Text('Crime Counts', style: kHead2Black),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard('Today', daily),
                      _buildStatCard('This Week', weekly),
                      _buildStatCard('This Month', monthly),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Text('Aggregates', style: kHead2Black),
                  _buildListTile('Most Common Crime', mostCommonCrime.key),
                  _buildListTile('Avg per Day', avgPerDay),
                  _buildListTile('Avg per Week', avgPerWeek),
                  _buildListTile('Total This Month', avgPerMonth),
                  const SizedBox(height: 36),
                  Text('Top 5 Crime Types', style: kHead2Black),
                  ...topCrimeTypes.map(
                    (e) => _buildListTile(e.key, e.value.toString()),
                  ),
                  const SizedBox(height: 36),
                  Text('Top 5 Locations', style: kHead2Black),
                  ...topLocations.map(
                    (e) => _buildListTile(e.key, e.value.toString()),
                  ),
                  const SizedBox(height: 36),
                  Text('Monthly Crime Trends', style: kHead2Black),
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries>[
                      LineSeries<MapEntry<String, int>, String>(
                        dataSource: timeSeries.entries.toList(),
                        xValueMapper: (entry, _) => entry.key,
                        yValueMapper: (entry, _) => entry.value,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _loadAllReports() async {
    final postsSnapshot = await FirebaseFirestore.instance
        .collection('Posts')
        .where('approved', isEqualTo: true)
        .get();

    final crimesSnapshot = await FirebaseFirestore.instance
        .collection('CrimeReports')
        .get();

    return [
      ...postsSnapshot.docs.map((e) => e.data() as Map<String, dynamic>),
      ...crimesSnapshot.docs.map((e) => e.data() as Map<String, dynamic>),
    ];
  }

  List<Map<String, dynamic>> _filterReports(
    List<Map<String, dynamic>> reports,
  ) {
    return reports.where((report) {
      final dateStr = report['date'];
      final date = DateTime.tryParse(dateStr.toString());
      final location = report['location'] ?? '';
      final matchDate =
          _selectedDateRange == null ||
          (date != null &&
              date.isAfter(
                _selectedDateRange!.start.subtract(const Duration(days: 1)),
              ) &&
              date.isBefore(
                _selectedDateRange!.end.add(const Duration(days: 1)),
              ));
      final matchLocation =
          _selectedLocation == null || _selectedLocation == location;
      return matchDate && matchLocation;
    }).toList();
  }

  List<MapEntry<String, int>> _topEntries(Map<String, int> map) {
    final entries = map.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(5).toList();
  }

  Widget _buildFilters(BuildContext context, List<String> locations) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                hint: const Text("Filter by location"),
                value: _selectedLocation,
                isExpanded: true,
                items: [null, ...locations].map((loc) {
                  return DropdownMenuItem<String>(
                    value: loc,
                    child: Text(loc ?? 'All Locations'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedLocation = val),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _selectedDateRange = picked);
              },
              child: const Text("Pick Date Range"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, int count) {
    return Card(
      color: Colors.blueGrey.shade700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('$count', style: kHead1White),
            Text(title, style: kBody2White),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, String value) {
    return ListTile(
      title: Text(title, style: kBody2Black),
      trailing: Text(value, style: kBody2Black),
    );
  }

  Future<void> _generatePdf({required bool includeFull}) async {
    final pdf = pw.Document();
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final logo = await imageFromAssetBundle('assets/logo.png');

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(child: pw.Image(logo, height: 60)),
          pw.SizedBox(height: 20),
          pw.Text(
            'Crime Report Dashboard',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text('Generated: $timestamp'),
          if (_selectedDateRange != null)
            pw.Text(
              'Date Filter: ${DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start)} to ${DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end)}',
            ),
          if (_selectedLocation != null)
            pw.Text('Location Filter: $_selectedLocation'),
          pw.Divider(),
          pw.Text('Top Crime Types'),
          ..._topEntries(
            _cachedReports.fold({}, (Map<String, int> acc, e) {
              final type = e['crime_type'] ?? e['crimeType'] ?? 'Unknown';
              acc[type] = (acc[type] ?? 0) + 1;
              return acc;
            }),
          ).map((e) => pw.Bullet(text: "${e.key}: ${e.value}")),
          pw.SizedBox(height: 20),
          pw.Text('Top Locations'),
          ..._topEntries(
            _cachedReports.fold({}, (Map<String, int> acc, e) {
              final loc = e['location'] ?? 'Unknown';
              acc[loc] = (acc[loc] ?? 0) + 1;
              return acc;
            }),
          ).map((e) => pw.Bullet(text: "${e.key}: ${e.value}")),
          if (includeFull) pw.SizedBox(height: 28),
          if (includeFull) pw.Text('Raw Data (Sample)'),
          if (includeFull)
            pw.Table.fromTextArray(
              headers: ['Date', 'Type', 'Location'],
              data: _cachedReports.take(10).map((e) {
                return [
                  e['date'],
                  e['crime_type'] ?? e['crimeType'],
                  e['location'],
                ];
              }).toList(),
            ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
