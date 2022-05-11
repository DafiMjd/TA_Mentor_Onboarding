import 'package:flutter/material.dart';
import 'package:ta_mentor_onboarding/utils/constans.dart';

class Space {
  static halfSpace() {
    return SizedBox(
      height: DEFAULT_PADDING / 2,
    );
  }
  static space() {
    return SizedBox(
      height: DEFAULT_PADDING,
    );
  }
  static doubleSpace() {
    return SizedBox(
      height: DEFAULT_PADDING * 2,
    );
  }
  static tripleSpace() {
    return SizedBox(
      height: DEFAULT_PADDING * 3,
    );
  }
}
