import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:ta_mentor_onboarding/models/jobtitle.dart';
import 'package:ta_mentor_onboarding/models/role.dart';
import 'package:ta_mentor_onboarding/models/user.dart';
import 'package:ta_mentor_onboarding/providers/base_provider.dart';
import 'dart:convert';

import 'package:ta_mentor_onboarding/utils/constans.dart';

class DashboardTabProvider extends BaseProvider {
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
          assignedActivities: 0,
          finishedActivities: 0,
        role: Role(id: 0, name: "null"),
          jobtitle: Jobtitle(
              id: 0, jobtitle_name: "null", jobtitle_description: "null"));
  get user => _user;
  set user(val) {
    _user = val;
    notifyListeners();
  }

  // Users
  Future<User> getUserInfo() async {
    // getAuthInfo();

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

  // =======

  
}


// Users
User parseUser(String responseBody) {
  try {
    final parsed = jsonDecode(responseBody);

    return User.fromJson(parsed);
  } catch (e) {
    rethrow;
  }
}
// =======
