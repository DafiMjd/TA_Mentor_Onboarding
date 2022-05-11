// ignore_for_file: non_constant_identifier_names

import 'package:ta_mentor_onboarding/models/activity.dart';
import 'package:ta_mentor_onboarding/models/activity_category.dart';

class ActivityOwned {
  int id;
  Activity activity;
  ActivityCategory category;
  DateTime start_date, end_date;
  String status, activity_note;
  bool validated;
  String? mentor_email;

  ActivityOwned(
      {required this.id,
      required this.activity,
      required this.category,
      required this.start_date,
      required this.end_date,
      required this.status,
      required this.validated,
      this.mentor_email,
      required this.activity_note});

  factory ActivityOwned.fromJson(Map<String, dynamic> json) {
    var startDate = DateTime.parse(json['start_date']);
    var endDate = DateTime.parse(json['end_date']);
    var note = (json['activity_note'] == null) ? '' : json['activity_note'];
    return ActivityOwned(
        id: json['id'],
        activity: Activity.fromJson(json['activities_']),
        category: ActivityCategory.fromJson(json['category_']),
        start_date: startDate,
        end_date: endDate,
        status: json['status'],
        validated: json['validated'],
        mentor_email: json['mentor_email'],
        activity_note: note);
  }
}
