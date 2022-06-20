import 'package:flutter/foundation.dart';
import 'package:ta_mentor_onboarding/models/activity_owned.dart';
import 'package:ta_mentor_onboarding/models/user.dart';
import 'package:ta_mentor_onboarding/providers/auth_provider.dart';
import 'package:ta_mentor_onboarding/providers/base_provider.dart';
import 'package:ta_mentor_onboarding/utils/constans.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ActivityDetailProvider extends BaseProvider {
  // Request API

  Future<ActivityOwned> editActOwnedStatus(
      int id, String email, String status) async {
    var _token = super.token;
    bool tokenValid = await checkToken();

    String url = "$BASE_URL/api/ActivitiesOwned/status";

    if (tokenValid) {
      try {
        var result = await http.put(Uri.parse(url),
            headers: {
              "Access-Control-Allow-Origin":
                  "*", // Required for CORS support to work
              "Access-Control-Allow-Methods": "GET",
              "Access-Control-Allow-Credentials": "true",
              "Access-Control-Expose-Headers": "Authorization, authenticated",
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $_token',
            },
            body:
                jsonEncode({"id": id, "user_email": email, "status": status}));

        if (result.statusCode == 400) {
          Map<String, dynamic> responseData = jsonDecode(result.body);
          throw responseData['errorMessage'];
        }
        if (result.statusCode == 502 || result.statusCode == 500) {
          throw "Server Down";
        }
        return compute(parseActivityOwned, result.body);
      } catch (e) {
        rethrow;
      }
    } else {
      logout();
      throw "you have been logged out";
    }
  }

  Future<User> editUserFinishedAct(String email, int finishedAct) async {
    String url = "$BASE_URL/api/User/finishedActivities";

    bool tokenValid = await checkToken();
    var _token = super.token;
    if (!tokenValid) {
      logout();
      throw 'you have been logged out';
    }

    try {
      var result = await http.put(Uri.parse(url),
          headers: {
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "GET",
            "Access-Control-Allow-Credentials": "true",
            "Access-Control-Expose-Headers": "Authorization, authenticated",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $_token',
          },
          body:
              jsonEncode({"email": email, "finishedActivities": finishedAct}));
      if (result.statusCode == 400) {
        Map<String, dynamic> responseData = jsonDecode(result.body);
        throw responseData['errorMessage'];
      }
      if (result.statusCode == 502 || result.statusCode == 500) {
        throw "Server Down";
      }
      return compute(parseUser, result.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> editUserProgress(String email, double progress) async {
    String url = "$BASE_URL/api/User/progress";
    bool tokenValid = await checkToken();
    var _token = super.token;
    if (!tokenValid) {
      logout();
      throw 'you have been logged out';
    }

    try {
      var result = await http.put(Uri.parse(url),
          headers: {
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "GET",
            "Access-Control-Allow-Credentials": "true",
            "Access-Control-Expose-Headers": "Authorization, authenticated",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $_token',
          },
          body: jsonEncode({"email": email, "progress": progress}));
      if (result.statusCode == 400) {
        Map<String, dynamic> responseData = jsonDecode(result.body);
        throw responseData['errorMessage'];
      }
      if (result.statusCode == 502 || result.statusCode == 500) {
        throw "Server Down";
      }
      return compute(parseUser, result.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editMentorEmail(
    int id,
    String email,
  ) async {
    String url = "$BASE_URL/api/ActivitiesOwned/mentor-email";
    bool tokenValid = await checkToken();
    var _token = super.token;
    var _email = super.email;
    if (!tokenValid) {
      logout();
      throw 'you have been logged out';
    }

    try {
      var result = await http.put(Uri.parse(url),
          headers: {
            "Access-Control-Allow-Origin":
                "*", // Required for CORS support to work
            "Access-Control-Allow-Methods": "GET",
            "Access-Control-Allow-Credentials": "true",
            "Access-Control-Expose-Headers": "Authorization, authenticated",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $_token',
          },
          body: jsonEncode(
              {"id": id, "user_email": email, "mentor_email": _email}));
      if (result.statusCode == 400) {
        print('dafi2');
        Map<String, dynamic> responseData = jsonDecode(result.body);
        throw responseData['errorMessage'];
      }
      if (result.statusCode == 502 || result.statusCode == 500) {
        throw "Server Down";
      }
      // return compute(parseUser, result.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<ActivityOwned> fetchActOwnedById(int id) async {
    String url = "$BASE_URL/api/ActivitiesOwnedById/$id";

    bool tokenValid = await checkToken();
    var _token = super.token;
    if (!tokenValid) {
      logout();
      throw 'you have been logged out';
    }

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

      if (result.body == []) {
        throw "No Data";
      }

      if (result.statusCode == 502 || result.statusCode == 500) {
        throw "Server Down";
      }

      if (result.statusCode == 400) {
        Map<String, dynamic> responseData = jsonDecode(result.body);
        throw responseData['errorMessage'];
      }

      return compute(parseActivityOwned, result.body);
    } catch (e) {
      rethrow;
    }
  }

  // ============

}

ActivityOwned parseActivityOwned(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return ActivityOwned.fromJson(parsed[0]);
}

User parseUser(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return User.fromJson(parsed[0]);
}
