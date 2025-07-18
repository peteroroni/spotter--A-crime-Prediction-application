import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotter/constant-widgets/bottom_nav_bar.dart';
import 'package:spotter/constants/colors.dart';

// You can tweak these globally or make them configurable
const double titleFontSize = 24;
const double valueFontSize = 24;

// Color settings per section
const Color categoryColor = Colors.deepPurple;
const Color placeColor = Colors.teal;
const Color dateColor = Colors.orange;
const Color defaultLabelColor = Colors.black;

class ReportDetailsView extends StatelessWidget {
  final String category;
  final String date;
  final String place;
  final String time;
  final String description;
  final String email;

  const ReportDetailsView({
    super.key,
    required this.category,
    required this.date,
    required this.place,
    required this.time,
    required this.description,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
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
          'Crime Report Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 248, 250, 250),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: Get.height * 0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildMultiRow(category, place, date),
              const SizedBox(height: 20),
              _buildTimeRow(time),
              const SizedBox(height: 20),
              _buildDescriptionBox(description),
              const SizedBox(height: 20),
              _buildPostedBy(email),
              const SizedBox(height: 30),
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultiRow(String category, String place, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelValueRow('A report of: ', category, categoryColor),
        const SizedBox(height: 8),
        _buildLabelValueRow('At: ', place, placeColor),
        const SizedBox(height: 8),
        _buildLabelValueRow('On: ', date, dateColor),
      ],
    );
  }

  Widget _buildLabelValueRow(String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
            color: defaultLabelColor,
          ),
        ),
        Expanded(
          child: Text(
            value.trim().isNotEmpty ? value : "Not available",
            style: TextStyle(fontSize: valueFontSize, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRow(String time) {
    final isValid = time.trim().isNotEmpty;
    return Text(
      "Time: ${isValid ? time : "Not available"}",
      style: TextStyle(fontSize: valueFontSize, color: Colors.black87),
    );
  }

  Widget _buildDescriptionBox(String description) {
    final isValid = description.trim().isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.white, offset: Offset(-3, -3), blurRadius: 6),
          BoxShadow(color: Colors.black12, offset: Offset(3, 3), blurRadius: 6),
        ],
      ),
      child: Text(
        isValid ? description : "Not available",
        style: TextStyle(fontSize: valueFontSize, color: Colors.grey[800]),
      ),
    );
  }

  Widget _buildPostedBy(String email) {
    final isValid = email.trim().isNotEmpty;

    return Align(
      alignment: Alignment.centerRight,
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 20),
          children: [
            const TextSpan(
              text: "Reported by: ",
              style: TextStyle(color: Colors.black38),
            ),
            TextSpan(
              text: isValid ? email : "Not available",
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 44,
      child: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Back",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
