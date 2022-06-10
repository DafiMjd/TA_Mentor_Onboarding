import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';

class ActivityCategory {
  int id, duration;
  String categoryName, categoryDesc;
  Color categoryColor;

  ActivityCategory(
      {required this.categoryName,
      required this.categoryColor,
      required this.id,
      required this.duration,
      required this.categoryDesc});

  factory ActivityCategory.fromJson(Map<String, dynamic> json) {
    // int id = json['id'];
    // late Color color;
    // if (id.isEven) {
    //   color = CATEGORY_CARD_HEAVY;
    // } else {
    //   color = CATEGORY_CARD_HEAVY;
    // }

    return ActivityCategory(
      id: json['id'],
      categoryName: json['category_name'],
      categoryDesc: json['category_description'],
      duration: json['duration'],
      categoryColor: CATEGORY_CARD);
  }
}
