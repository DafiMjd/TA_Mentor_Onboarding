
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ta_mentor_onboarding/utils/auth_secure_storage.dart';
import 'package:ta_mentor_onboarding/utils/constans.dart';

class BaseProvider extends ChangeNotifier {

  late String _token, _email;
  void recieveToken(auth) {
    _token = auth.token;
    _email = auth.email;
    notifyListeners();
  }

  get token => _token;
  get email => _email;

  bool _isFetchingData = false;
  get isFetchingData => _isFetchingData;
  set isFetchingData(val) {
    _isFetchingData = val;
  }

  // API

  Future<bool> checkToken() async {
    String url = "$BASE_URL/api/checkToken/$_email?token=$_token";

    try {
      var result = await http.get(
        Uri.parse(url),
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
      if (result.statusCode == 404) {
        throw "Not Found";
      }
      if (result.statusCode == 502 || result.statusCode == 500) {
        throw "Server Down";
      }
      if (result.statusCode == 400) {
        return false;
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await AuthSecureStorage.deleteAll();

    String apiURL = "$BASE_URL/api/deleteToken";

    
  }



  // =========

}