// import 'package:intl/intl.dart';
import 'package:ta_mentor_onboarding/models/jobtitle.dart';

class User {
  double progress;

  String email, name, gender, phone_number;
  String birtdate;
  Jobtitle jobtitle;

  User({
    required this.email,
    required this.name,
    required this.gender,
    required this.phone_number,
    required this.progress,
    required this.birtdate,
    required this.jobtitle,
  });

  factory User.createUser(Map<String, dynamic> json) {
    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final DateTime birtDate = DateTime.parse(json['birthdate']);
    // final String dateFormatted = formatter.format(birtDate);


    return User(
        email: json['email'],
        name: json['name'],
        gender: json['gender'],
        phone_number: json['phone_number'],
        progress: json['progress'].toDouble(),
        jobtitle: Jobtitle.fromJson(json['jobtitle_']),
        birtdate: json['birthdate']);
  }
}
