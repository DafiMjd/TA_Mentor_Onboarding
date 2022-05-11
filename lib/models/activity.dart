// ignore_for_file: non_constant_identifier_names

import 'package:ta_mentor_onboarding/models/activity_category.dart';

class Activity {
  int id;
  String activity_name, activity_description;
  ActivityCategory category;

  Activity(
      {required this.id,
      required this.activity_name,
      required this.activity_description,
      required this.category});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      activity_name: json['activity_name'],
      activity_description: json['activity_description'],
      category: ActivityCategory.fromJson(json['category_']),
    );
  }
}
