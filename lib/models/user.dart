// import 'package:intl/intl.dart';
import 'package:ta_mentor_onboarding/models/jobtitle.dart';
import 'package:ta_mentor_onboarding/models/role.dart';

class User {
  double progress;

  String email, name, gender, phone_number;
  String birtdate;
  Jobtitle? jobtitle;
  Role? role;
  int assignedActivities, finishedActivities;


  User({
    required this.email,
    required this.name,
    required this.gender,
    required this.phone_number,
    required this.progress,
    required this.birtdate,
    required this.jobtitle,
    required this.role,
    required this.assignedActivities,
    required this.finishedActivities
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final DateTime birtDate = DateTime.parse(json['birthdate']);
    // final String dateFormatted = formatter.format(birtDate);


    var jobtitle = (json['jobtitle_'] == null)
        ? null
        : Jobtitle.fromJson(json['jobtitle_']);
    var role = (json['role_'] == null)
        ? null
        : Role.fromJson(json['role_']);


    return User(
        email: json['email'],
        name: json['name'],
        gender: json['gender'],
        phone_number: json['phone_number'],
        progress: json['progress'].toDouble(),
        jobtitle: jobtitle,
        birtdate: json['birthdate'],
        role: role,
        assignedActivities: json['assignedActivities'],
        finishedActivities: json['finishedActivities']);
  }
}
