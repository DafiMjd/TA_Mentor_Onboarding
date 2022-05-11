import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/providers/auth_provider.dart';
import 'package:ta_mentor_onboarding/providers/profile/change_password_provider.dart';
import 'package:ta_mentor_onboarding/utils/constans.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late final TextEditingController _curPassCtrl;
  late final TextEditingController _newPassCtrl;
  late final TextEditingController _confirmPassCtrl;

  late ChangePasswordProvider changePassProv;
  late AuthProvider authProv;

  @override
  void initState() {
    super.initState();
    _curPassCtrl = TextEditingController();
    _newPassCtrl = TextEditingController();
    _confirmPassCtrl = TextEditingController();

    authProv = Provider.of<AuthProvider>(context, listen: false);
  }

  void _changePassword(String curPass, String newPass) async {

    changePassProv.isSaveButtonDisabled = true;

    try {
      await changePassProv.changePassword(curPass, newPass);
      Navigator.pop(context);
      authProv.logout();
      changePassProv.isSaveButtonDisabled = false;
    } catch (e) {
      changePassProv.isSaveButtonDisabled = false;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("HTTP Error"),
              content: Text("$e"),
              actions: [
                TextButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    child: Text("okay"))
              ],
            );
          });
    }
    changePassProv.isSaveButtonDisabled = false;
  }

  @override
  Widget build(BuildContext context) {
    changePassProv = context.watch<ChangePasswordProvider>();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Change Password",
          ),
          foregroundColor: Colors.black,
          backgroundColor: ORANGE_GARUDA,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Fullname
                      titleField("Current Password",
                          changePassProv.isCurPassFieldEmpty),
                      SizedBox(
                        height: DEFAULT_PADDING,
                      ),
                      TextFormField(
                          onChanged: (value) => changePassProv
                              .isCurPassFieldEmpty = _curPassCtrl.text.isEmpty,
                          obscureText: changePassProv.isCurPassHidden,
                          controller: _curPassCtrl,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              suffix: InkWell(
                                  onTap: () =>
                                      changePassProv.changeCurPassHidden(),
                                  child: Icon(changePassProv.isCurPassHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility)))),
                      SizedBox(
                        height: DEFAULT_PADDING,
                      ),

                      // Password
                      titleField(
                          "New Password", changePassProv.isNewPassFieldEmpty),
                      SizedBox(
                        height: DEFAULT_PADDING,
                      ),
                      TextFormField(
                          onChanged: (value) => changePassProv
                              .isNewPassFieldEmpty = _newPassCtrl.text.isEmpty,
                          obscureText: changePassProv.isNewPassHidden,
                          controller: _newPassCtrl,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              suffix: InkWell(
                                  onTap: () =>
                                      changePassProv.changeNewPassHidden(),
                                  child: Icon(changePassProv.isNewPassHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility)))),
                      SizedBox(
                        height: DEFAULT_PADDING,
                      ),

                      // Confirm Password
                      titleField("Confirm Password",
                          changePassProv.isConfPassFieldEmpty),
                      SizedBox(
                        height: DEFAULT_PADDING,
                      ),
                      TextFormField(
                          onChanged: (value) =>
                              changePassProv.isConfPassFieldEmpty =
                                  _confirmPassCtrl.text.isEmpty,
                          obscureText: changePassProv.isConfPassHidden,
                          controller: _confirmPassCtrl,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              suffix: InkWell(
                                  onTap: () =>
                                      changePassProv.changeConfPassHidden(),
                                  child: Icon(changePassProv.isConfPassHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility)))),
                      SizedBox(
                        height: DEFAULT_PADDING,
                      ),
                      Visibility(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "* Passwords don't match",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        visible: changePassProv.isPassDifferent,
                      ),

                      SizedBox(
                        height: DEFAULT_PADDING * 2,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: changePassProv.isSaveButtonDisabled
                                ? Colors.blue[300]
                                : Colors.blue),
                        onPressed: (changePassProv.isSaveButtonDisabled)
                            ? () {}
                            : () {
                                if (_curPassCtrl.text.isNotEmpty &&
                                    _newPassCtrl.text.isNotEmpty &&
                                    _confirmPassCtrl.text.isNotEmpty) {
                                  // validate wheter new pass and conf pass same
                                  changePassProv.isPassDifferent =
                                      _newPassCtrl.text !=
                                          _confirmPassCtrl.text;
                                  if (!changePassProv.isPassDifferent) {
                                    _changePassword(
                                        _curPassCtrl.text, _newPassCtrl.text);
                                  }
                                  ;
                                }
                              },
                        child: changePassProv.isSaveButtonDisabled
                            ? Text(
                                "Wait",
                              )
                            : Text(
                                "Save Changes",
                              ),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }

  Container titleField(title, isEmpty) => Container(
      alignment: Alignment.centerLeft,
      child: (isEmpty)
          ? Text(
              title + "*",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),
            )
          : Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ));
}
