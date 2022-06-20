import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:ta_mentor_onboarding/providers/base_provider.dart';
import 'dart:convert';

import 'package:ta_mentor_onboarding/utils/constans.dart';

class ChangePasswordProvider extends BaseProvider {
  bool _isCurPassFieldEmpty = true;
  bool _isNewPassFieldEmpty = true;
  bool _isConfPassFieldEmpty = true;

  bool get isCurPassFieldEmpty => _isCurPassFieldEmpty;
  bool get isNewPassFieldEmpty => _isNewPassFieldEmpty;
  bool get isConfPassFieldEmpty => _isConfPassFieldEmpty;

  set isCurPassFieldEmpty(bool val) {
    _isCurPassFieldEmpty = val;
    notifyListeners();
  }

  set isNewPassFieldEmpty(bool val) {
    _isNewPassFieldEmpty = val;
    notifyListeners();
  }

  set isConfPassFieldEmpty(bool val) {
    _isConfPassFieldEmpty = val;
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

  // password hide
  bool _isCurPassHidden = true;

  bool get isCurPassHidden => _isCurPassHidden;
  void changeCurPassHidden() {
    _isCurPassHidden = !_isCurPassHidden;
    notifyListeners();
  }

  bool _isNewPassHidden = true;

  bool get isNewPassHidden => _isNewPassHidden;
  void changeNewPassHidden() {
    _isNewPassHidden = !_isNewPassHidden;
    notifyListeners();
  }

  bool _isConfPassHidden = true;

  bool get isConfPassHidden => _isConfPassHidden;
  void changeConfPassHidden() {
    _isConfPassHidden = !_isConfPassHidden;
    notifyListeners();
  }
  // ==========================

  // validate new pass and conf pass
  bool _isPassDifferent = false;
  get isPassDifferent => _isPassDifferent;
  set isPassDifferent(val) {
    _isPassDifferent = val;
  }

  // Change Password
  Future<void> changePassword(String curPass, String newPass) async {
    // getAuthInfo();
    String apiURL = "$BASE_URL/api/User/edit-password";

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
            "password": curPass,
            "new_password": newPass,
          }));

      
      if (result.statusCode == 502 || result.statusCode == 500) {
        throw "Server Down";
      }

      Map<String, dynamic> responseData = jsonDecode(result.body);
      if (result.statusCode == 400) {
        throw responseData['errorMessage'];
      }
    } catch (e) {
      rethrow;
    }
  }
  // =======
}
