import 'package:flutter/foundation.dart';


import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ta_mentor_onboarding/models/user.dart';
import 'package:ta_mentor_onboarding/providers/base_provider.dart';
import 'package:ta_mentor_onboarding/utils/constans.dart';

class EditProfileProvider extends BaseProvider {

  bool _isEmailFieldEmpty = false;
  bool _isNameFieldEmpty = false;
  bool _isPhoneNumFieldEmpty = false;

  bool get isEmailFieldEmpty => _isEmailFieldEmpty;
  bool get isNameFieldEmpty => _isNameFieldEmpty;
  bool get isPhoneNumFieldEmpty => _isPhoneNumFieldEmpty;


  set isEmailFieldEmpty(bool val) {
    _isEmailFieldEmpty = val;
    notifyListeners();
  }
  set isNameFieldEmpty(bool val) {
    _isNameFieldEmpty = val;
    notifyListeners();
  }
  set isPhoneNumFieldEmpty(bool val) {
    _isPhoneNumFieldEmpty = val;
    notifyListeners();
  }

  // button disable after save
  bool _isSaveButtonDisabled = false;

  bool get isSaveButtonDisabled => _isSaveButtonDisabled;
  set isSaveButtonDisabled(bool val) {
    _isSaveButtonDisabled = val;
    notifyListeners();
  }
  // ==========================

  // Users
  Future<User> getUserInfo() async {
    bool tokenValid = await checkToken();
    var _token = super.token;
    var _email = super.email;
    if (!tokenValid) {
      logout();
      throw 'you have been logged out';
    }
    String apiURL = "$BASE_URL/api/User/$_email";

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

      return compute(parseUser, result.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> editProfile(
      String name, String gender, String phoneNum, String date, int role_id, int jobtitle_id) async {
    // getAuthInfo();
    String apiURL = "$BASE_URL/api/User/";
    bool tokenValid = await checkToken();
    var _token = super.token;
    var _email = super.email;
    if (!tokenValid) {
      logout();
      throw 'you have been logged out';
    }

    try {
      var result = await http.put(Uri.parse(apiURL),
          headers: {
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "GET",
            "Access-Control-Allow-Credentials": "true",
            "Access-Control-Expose-Headers": "Authorization, authenticated",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $_token',
          },
          body: jsonEncode({
            "email": _email,
            "name": name,
            "role_id": role_id,
            "jobtitle_id": jobtitle_id,
            "gender": gender,
            "birthdate": date,
            "phone_number": phoneNum,
          }));

      
      if (result.statusCode == 502 || result.statusCode == 500) {
        throw "Server Down";
      }

      return getUserInfo();
    } catch (e) {

      rethrow;
    }
  }
  // =======
  
}

User parseUser(String responseBody) {
  try {
    final parsed = jsonDecode(responseBody);

    return User.fromJson(parsed);
  } catch (e) {
    rethrow;
  }
}