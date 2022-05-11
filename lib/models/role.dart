// import 'package:intl/intl.dart';

class Role {
  int id;
  String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final DateTime birtDate = DateTime.parse(json['birthdate']);
    // final String dateFormatted = formatter.format(birtDate);


    return Role(
        id: json['id'],
        name: json['role_name'],);
  }
}
