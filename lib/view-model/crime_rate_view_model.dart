import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CrimeRateViewModel extends ChangeNotifier {
  Future<Map<String, dynamic>> getTopCrimes() async {
    try {
      String url = 'http://13.126.116.79/api/v1/reports/rate/';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body;
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong');
        return {};
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      rethrow;
    }
  }
}
