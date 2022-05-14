// ignore_for_file: non_constant_identifier_names

import 'package:ta_mentor_onboarding/models/activity_category.dart';

class Activity {
  int id;
  String activity_name, activity_description;
  ActivityCategory? category;

  Activity(
      {required this.id,
      required this.activity_name,
      required this.activity_description,
      required this.category});

  factory Activity.fromJson(Map<String, dynamic> json) {
    var cat = (json['category_'] == null) ? null : ActivityCategory.fromJson(json['category_']);
    return Activity(
      id: json['id'],
      activity_name: json['activity_name'],
      activity_description: json['activity_description'],
      category: cat,
    );
  }
}
