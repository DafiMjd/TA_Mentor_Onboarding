import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/providers/auth_provider.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthProvider loginPageProvider = context.watch<AuthProvider>();

    void _login(String email, String password) {
      loginPageProvider.isLoginButtonDisabled = true;
      loginPageProvider.auth(email, password).catchError((onError) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Auth Error"),
                content: Text("$onError"),
                actions: [
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      child: Text("okay"))
                ],
              );
            });
      });
      // loginPageProvider.isLoginButtonDisabled = false;
    }

    Card BuildAuthCard() {
      return Card(
        elevation: 5,
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Login to your account",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              TextFormField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(200),
                ],
                controller: _emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Email"),
              ),
              Visibility(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "* Email harus diisi",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                visible: loginPageProvider.isEmailFieldEmpty,
              ),
              TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(200),
                  ],
                  obscureText: loginPageProvider.isPasswordHidden,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      suffix: InkWell(
                          onTap: () => loginPageProvider.changePasswordHidden(),
                          child: Icon(loginPageProvider.isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility)))),
              Visibility(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "* Password harus diisi",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                visible: loginPageProvider.isPasswordFieldEmpty,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                      onTap: () {},
                      child: Text("Forgot Password?",
                          style: TextStyle(fontWeight: FontWeight.w500)))),
              IgnorePointer(
                ignoring: loginPageProvider.isLoginButtonDisabled,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: loginPageProvider.isLoginButtonDisabled
                            ? Colors.blue[300]
                            : Colors.blue),
                    onPressed: () {
                      if (_emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty) {
                        loginPageProvider.isEmailFieldEmpty =
                            _emailController.text.isEmpty;
                        loginPageProvider.isPasswordFieldEmpty =
                            _passwordController.text.isEmpty;
                        _login(_emailController.text, _passwordController.text);
                      } else {
                        loginPageProvider.isEmailFieldEmpty =
                            _emailController.text.isEmpty;
                        loginPageProvider.isPasswordFieldEmpty =
                            _passwordController.text.isEmpty;
                      }
                    },
                    child: loginPageProvider.isLoginButtonDisabled
                        ? Text("Wait")
                        : Text("Login")),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(children: [
            Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.height / 3,
                    child: Image.asset('assets/images/logo_garuda.png'),
                  ),
                  Text("Onboarding HR",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: BROWN_GARUDA)),
                  Text("Mentor",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: BROWN_GARUDA)),
                ],
              ),
            ),
            Divider(height: 30, color: Colors.transparent),
            Center(
              child: Container(
                margin: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: BuildAuthCard(),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
