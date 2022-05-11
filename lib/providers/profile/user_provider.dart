import 'package:flutter/cupertino.dart';

import 'package:ta_mentor_onboarding/models/user.dart';


class UserProvider extends ChangeNotifier {

  late User _user;
  void receiveUser(user) {
    _user = user;
  }
  get user => _user;
  

 }
