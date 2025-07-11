import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotter/constants/colors.dart';

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
        backgroundColor: kPrimaryColor,
        title: const Text("Crime Report Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Get.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow("Category", category),
            _buildDetailRow("Date", date),
            _buildDetailRow("Place", place),
            _buildDetailRow("Time", time),
            _buildDetailRow("Description", description),
            _buildDetailRow("Posted by", email),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    final isValueValid = value.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isValueValid ? value : 'Not available',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
