import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:ta_mentor_onboarding/models/activity_owned.dart';
import 'dart:convert';

import 'package:ta_mentor_onboarding/models/status_menu.dart';
import 'package:ta_mentor_onboarding/utils/constans.dart';

class BrowseActivityProvider extends ChangeNotifier {
  List<StatusMenu> _menus = [
    StatusMenu(id: "all_activity", statusName: "All Activity", selected: false),
    StatusMenu(id: "assigned", statusName: "Assigned", selected: false),
    StatusMenu(id: "on_progress", statusName: "On Progress", selected: false),
    StatusMenu(id: "submittted", statusName: "Submitted", selected: false),
    StatusMenu(id: "late", statusName: "Late", selected: false),
    StatusMenu(id: "Rejected", statusName: "Rejected", selected: false),
    StatusMenu(id: "completed", statusName: "Completed", selected: false),
  ];

  List<StatusMenu> get menus => _menus;
  set menus(val) {
    _menus = val;
    // notifyListeners();
  }

  Container _content = Container();
  get content => _content;
  set content(val) {
    _content = val;
    // notifyListeners();
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

  // API Request

  Future<List<ActivityOwned>> fetchActOwnedByUser(String email) async {
    String url = "$BASE_URL/api/ActivitiesOwned/$email";

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

Future<List<ActivityOwned>> fetchActOwnedByUserByStatus(String email, String status) async {
    String url = "$BASE_URL/api/ActivitiesOwned/$email/$status";

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

  // =======

}

List<ActivityOwned> parseActivitiesOwned(String responseBody) {
  List<Map<String, dynamic>> parsed =
      jsonDecode(responseBody).cast<Map<String, dynamic>>();

      print(parsed);

  return parsed
      .map<ActivityOwned>((json) => ActivityOwned.fromJson(json))
      .toList();
}
