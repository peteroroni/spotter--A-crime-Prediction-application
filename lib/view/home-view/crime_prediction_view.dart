import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:spotter/constant-widgets/bottom_nav_bar.dart';
import 'package:spotter/prediction/crime_prediction_service.dart';

class CrimePredictionPage extends StatefulWidget {
  const CrimePredictionPage({Key? key}) : super(key: key);

  @override
  State<CrimePredictionPage> createState() => _CrimePredictionPageState();
}

class _CrimePredictionPageState extends State<CrimePredictionPage> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, Map<String, double>> _locationCoordinates = {
    'Cherry Park': {'lat': -1.0990, 'lng': 37.0150},
    'Gachororo': {'lat': -1.1020, 'lng': 37.0105},
    'Gate B': {'lat': -1.0955, 'lng': 37.0110},
    'Gate C': {'lat': -1.0952, 'lng': 37.0135},
    'JKUAT hostels area': {'lat': -1.0970, 'lng': 37.0130},
    'Highpoint': {'lat': -1.1045, 'lng': 37.0118},
    'JKUAT Enterprises LTD.': {'lat': -1.0945, 'lng': 37.0160},
    'JKUAT Hospital': {'lat': -1.0960, 'lng': 37.0120},
    'JKUAT Main Gate': {'lat': -1.0950, 'lng': 37.0100},
    'JKUAT SAJOREC Botanical Garden': {'lat': -1.0995, 'lng': 37.0170},
    'Juja City Mall': {'lat': -1.1025, 'lng': 37.0080},
    'Juja Market': {'lat': -1.1012, 'lng': 37.0075},
    'Juja Police Station': {'lat': -1.1010, 'lng': 37.0065},
    'Juja Square': {'lat': -1.1000, 'lng': 37.0070},
    'Juja Stage': {'lat': -1.0998, 'lng': 37.0060},
  };

  String? _selectedLocation;
  double? _latitude;
  double? _longitude;
  DateTime? _selectedDateTime = DateTime.now();
  bool _isLoading = false;

  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _onLocationChanged(String? newLocation) {
    setState(() {
      _selectedLocation = newLocation;
      if (_locationCoordinates.containsKey(newLocation)) {
        final coords = _locationCoordinates[newLocation]!;
        _latitude = coords['lat'];
        _longitude = coords['lng'];
        _latController.text = _latitude.toString();
        _lngController.text = _longitude.toString();
      } else {
        _latitude = null;
        _longitude = null;
        _latController.clear();
        _lngController.clear();
      }
    });
  }

  Future<void> _submitPrediction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_latitude == null || _longitude == null) {
      _showDialog("Input Error", "Please enter valid coordinates.");
      return;
    }

    final String dayOfWeek = DateFormat('EEEE').format(_selectedDateTime!);
    setState(() => _isLoading = true);

    try {
      final result = await CrimePredictionService().predictCrime(
        location: _selectedLocation!,
        dayOfWeek: dayOfWeek,
        latitude: _latitude!,
        longitude: _longitude!,
      );

      final String prediction = result['crime_type'];
      final String formattedDate = DateFormat(
        'yyyy-MM-dd',
      ).format(_selectedDateTime!);
      final String formattedTime = DateFormat(
        'kk:mm',
      ).format(_selectedDateTime!);

      _showDialog(
        "Prediction Result",
        null,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "Selected: ",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: "$formattedDate At $formattedTime",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Likely Crime: ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: prediction,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),
            const Text(
              "This prediction is based on historical data and patterns. "
              "Always prioritize your safety and use your judgment.",
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        onConfirm: () {
          _formKey.currentState!.reset();
          setState(() {
            _selectedLocation = null;
            _latitude = null;
            _longitude = null;
            _latController.clear();
            _lngController.clear();
            _selectedDateTime = DateTime.now();
          });
        },
      );
    } catch (e) {
      _showDialog("Error", "Prediction failed: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDialog(
    String title,
    String? message, {
    Widget? content,
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: content ?? Text(message ?? ""),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onConfirm != null) onConfirm();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final DateTime now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? now,
      firstDate: now,
      lastDate: DateTime(2030),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? now),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String datePreview = _selectedDateTime == null
        ? "No date selected"
        : DateFormat('yyyy-MM-dd – kk:mm').format(_selectedDateTime!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 125, 139),

        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 250, 248, 248),
          ),
          onPressed: () => Get.offAll(() => BottomNavigationBarWidget()),
        ),
        centerTitle: true,
        title: const Text(
          'Crime Prediction',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 248, 250, 250),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Instructions:\n\n'
                  '1. Select a location from the dropdown.\n'
                  '2. Pick a date and time of interest.\n'
                  '3. Tap "Predict Crime" to see the likely crime type.\n\n'
                  'Note: This is from an AI-based Machine Learning model and it is purely experimental. Use the results as guidance only.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 108),
                DropdownButtonFormField<String>(
                  value: _selectedLocation,
                  decoration: const InputDecoration(
                    labelText: 'Select Location',
                    border: OutlineInputBorder(),
                  ),
                  items: _locationCoordinates.keys.map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: _onLocationChanged,
                  validator: (value) =>
                      value == null ? 'Please select a location' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _latController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lngController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Selected: $datePreview",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _pickDateTime,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Pick a Date & Time',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submitPrediction,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Predict Crime',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                const SizedBox(height: 40),
                const Text(
                  "Disclaimer: This prediction is experimental and based on historical patterns. "
                  "It may not reflect real-time or actual threats. Always use your own judgment and stay safe.",
                  style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
