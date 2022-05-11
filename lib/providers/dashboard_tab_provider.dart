import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:ta_mentor_onboarding/models/jobtitle.dart';
import 'package:ta_mentor_onboarding/models/user.dart';
import 'dart:convert';

import 'package:ta_mentor_onboarding/utils/constans.dart';

class DashboardTabProvider with ChangeNotifier {
  int _botNavBarIndex = 0;
  get botNavBarIndex => _botNavBarIndex;
  set botNavBarIndex(val) {
    _botNavBarIndex = val;
  }

  int _tab = HOME_PAGE;
  int get tab => _tab;
  set tab(int val) {
    _tab = val;
    notifyListeners();
  }

  User _user = User(
          email: "null",
          name: "null",
          gender: "null",
          phone_number: "null",
          progress: 0,
          birtdate: "null",
          jobtitle: Jobtitle(
              id: 0, jobtitle_name: "null", jobtitle_description: "null"));
  get user => _user;
  set user(val) {
    _user = val;
    notifyListeners();
  }

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

  // Users
  Future<User> getUserInfo() async {
    // getAuthInfo();
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

      if (result.statusCode == 502) {
        throw "Server Down";
      }

      return compute(parseUser, result.body);
    } catch (e) {
      print("dafi e" + e.toString());
      rethrow;
    }
  }

  // =======

  // Acitivy Category
  // =======
  
}

// Acitivy Category

// =======

// Users
User parseUser(String responseBody) {
  try {
    final parsed = jsonDecode(responseBody);

    return User.createUser(parsed);
  } catch (e) {
    rethrow;
  }
}
// =======
