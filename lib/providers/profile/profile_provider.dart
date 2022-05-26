import 'package:flutter/material.dart';

import 'package:ta_mentor_onboarding/utils/constans.dart';

import 'package:http/http.dart' as http;

class ProfileProvider extends ChangeNotifier {
  late String _token, _email;
  void recieveToken(auth) {
    _token = auth.token;
    _email = auth.email;
    notifyListeners();
  }

  bool _isFetchingData = false;
  get isFetchingData => _isFetchingData;
  set isFetchingData(val) {
    _isFetchingData = val;
  }

  // API Request

  Future<dynamic> getProfPic(link) async {
    String apiURL = BASE_URL + '/' + link;

    try {
      var result = await http.get(
        Uri.parse(apiURL),
        headers: {
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Methods": "GET",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Expose-Headers": "Authorization, authenticated",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token',
        },
      );

      if (result.statusCode == 502 || result.statusCode == 500) {
        throw "Server Down";
      }
      return result.body;
    } catch (e) {
      rethrow;
    }
  }

  // ========
}
