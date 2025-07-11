import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CrimeTypeViewModel extends ChangeNotifier {
  int count = 0;
  bool isLoading = false;

  Future<Map<String, dynamic>> getSearchCrimes(
      String location, String category, String date) async {
    isLoading = true;
    notifyListeners();
    try {
      String url =
          'http://13.126.116.79/api/v1/reports/search?crime_location=$location&crime_category=$category&report_date=$date';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['data']['items'] != null && body['data']['items'].isNotEmpty) {
          count = body['data']['count'];

          isLoading = false;
          notifyListeners();

          return body;
        } else {
          isLoading = false;
          notifyListeners();
          Fluttertoast.showToast(msg: 'No Crime found');
          return {};
        }
      } else {
        isLoading = false;
        notifyListeners();
        Fluttertoast.showToast(msg: 'Something went wrong');

        return {};
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: 'Something went wrong');

      rethrow;
    }
  }
}
