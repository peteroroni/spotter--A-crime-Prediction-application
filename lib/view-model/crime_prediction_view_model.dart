import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class CrimePredictionViewModel extends ChangeNotifier {
  bool isLoading = false;
  double prediction = 0.0;
  Future<Map<String, dynamic>> getPrediction(
      String location, String date) async {
    isLoading = true;
    notifyListeners();
    dynamic jsonResponse;
    try {
      Map<String, dynamic> requestBody = {
        'crime_location': location,
        'crime_date': date,
      };

      String jsonBody = jsonEncode(requestBody);

      var response = await post(
          Uri.parse('http://13.126.116.79/api/v1/predict/'),
          body: jsonBody,
          headers: {
            'Content-Type': 'application/json',
          });

      if (response.statusCode == 200) {
        jsonResponse = jsonDecode(response.body);

        prediction = double.parse(jsonResponse['data']['prediction']);

        isLoading = false;
        notifyListeners();
        return jsonResponse;
      } else {
        isLoading = false;
        notifyListeners();
        Fluttertoast.showToast(msg: 'Something went wrong');
        return {};
      }
    } catch (e) {
      isLoading = true;
      notifyListeners();
      Fluttertoast.showToast(msg: 'Something went wrong');
      rethrow;
    }
  }
}
