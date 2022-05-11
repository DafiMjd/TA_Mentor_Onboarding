import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ta_mentor_onboarding/utils/auth_secure_storage.dart';
import 'package:ta_mentor_onboarding/utils/constans.dart';

class AuthProvider with ChangeNotifier {
  late bool _isAuth = false;
  late String _token, _email;
  late DateTime _expiryDate;

  String get token => _token;
  String get email => _email;

  Future<void> _getAuthInfo() async {
    try {
      _token = await AuthSecureStorage.getToken();
      _expiryDate = await AuthSecureStorage.getExpiryDate();
      _email = await AuthSecureStorage.getEmail();



      if (_expiryDate.isAfter(DateTime.now()))
        _setIsAuth(true);
      else
        _setIsAuth(false);
    } catch (e) {
      _setIsAuth(false);
    }
  }

  bool getIsAuth() {
    _getAuthInfo();
    return _isAuth;
  }

  void _setIsAuth(bool val) {
    _isAuth = val;
    notifyListeners();
  }

  Future<void> _storeAuthInfo(String token, int expiresIn, String email) async {
    DateTime _expiryDate = DateTime.now().add(Duration(seconds: expiresIn));

    await AuthSecureStorage.setToken(token);
    await AuthSecureStorage.setExpiryDate(_expiryDate);
    await AuthSecureStorage.setEmail(email);
  }

  Future<void> auth(String email, String password) async {
    String apiURL = "$BASE_URL/api/Auth/login-mentor";

    try {
      var apiResult = await http.post(Uri.parse(apiURL),
          headers: {
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "POST",
            "Access-Control-Allow-Credentials": "true",
            "Access-Control-Expose-Headers": "Authorization, authenticated",
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode({"email": email, "password": password}));


      Map<String, dynamic> responseData = jsonDecode(apiResult.body);

      if (apiResult.statusCode == 400) {
        throw responseData['errorMessage'];
      }

      _storeAuthInfo(responseData['token'],
          int.parse(responseData['expiresIn']), responseData['email']);
      notifyListeners();

      isLoginButtonDisabled = false;
    } catch (e) {
      isLoginButtonDisabled = false;
      throw e;
    }
  }

  Future<void> logout() async{
    
    await AuthSecureStorage.deleteAll();
    notifyListeners();
  }

  // button disable after login
  bool _isLoginButtonDisabled = false;

  bool get isLoginButtonDisabled => _isLoginButtonDisabled;
  set isLoginButtonDisabled(bool val) {
    _isLoginButtonDisabled = val;
    notifyListeners();
  }
  // ==========================

  // form validation
  bool _isEmailFieldEmpty = false;
  bool _isPasswordFieldEmpty = false;

  bool get isEmailFieldEmpty => _isEmailFieldEmpty;
  bool get isPasswordFieldEmpty => _isPasswordFieldEmpty;
  set isEmailFieldEmpty(bool val) {
    _isEmailFieldEmpty = val;
    notifyListeners();
  }

  set isPasswordFieldEmpty(bool val) {
    _isPasswordFieldEmpty = val;
    notifyListeners();
  }
  // ==========================

  // password hide
  bool _isPasswordHidden = true;

  bool get isPasswordHidden => _isPasswordHidden;
  void changePasswordHidden() {
    _isPasswordHidden = !_isPasswordHidden;
    notifyListeners();
  }
  // ==========================


}
