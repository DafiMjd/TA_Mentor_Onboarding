import 'package:flutter/foundation.dart';
import 'package:ta_mentor_onboarding/models/activity_owned.dart';
import 'package:ta_mentor_onboarding/providers/base_provider.dart';
import 'package:ta_mentor_onboarding/utils/constans.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeProvider extends BaseProvider {

  // API Request

  Future<List<ActivityOwned>> fetchActOwnedByStatus(String status) async {
    String url = "$BASE_URL/api/ActivitiesOwnedByStatus/$status";

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
        return [];
      }

      if (result.statusCode == 502 || result.statusCode == 500) {
        throw "Server Down";
      }

      if (result.statusCode == 400) {
        Map<String, dynamic> responseData = jsonDecode(result.body);
        throw responseData['errorMessage'];
      }

      return compute(parseActivitiesOwned, result.body);
    } catch (e) {
      rethrow;
    }
  }

  // ==========

}

List<ActivityOwned> parseActivitiesOwned(String responseBody) {
  List<Map<String, dynamic>> parsed =
      jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<ActivityOwned>((json) => ActivityOwned.fromJson(json))
      .toList();
}
