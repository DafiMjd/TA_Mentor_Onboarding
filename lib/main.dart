import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/providers/auth_provider.dart';
import 'package:ta_mentor_onboarding/providers/dashboard_tab_provider.dart';
import 'package:ta_mentor_onboarding/providers/profile/change_password_provider.dart';
import 'package:ta_mentor_onboarding/providers/profile/edit_profile_provider.dart';
import 'package:ta_mentor_onboarding/providers/profile/user_provider.dart';
import 'package:ta_mentor_onboarding/views/dashboard_page.dart';
import 'package:ta_mentor_onboarding/views/test_home.dart';
import 'package:ta_mentor_onboarding/views/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => DashboardTabProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProxyProvider<AuthProvider, DashboardTabProvider>(
          create: (context) => DashboardTabProvider(),
          update: (context, authProv, dashPorv) {
              if (dashPorv != null) {

              return dashPorv..recieveToken(authProv);
              }
                return DashboardTabProvider();

          }
        ),
        ChangeNotifierProxyProvider<AuthProvider, ChangePasswordProvider>(
          create: (context) => ChangePasswordProvider(),
          update: (context, authProv, dashPorv) {
              if (dashPorv != null) {

              return dashPorv..recieveToken(authProv);
              }
                return ChangePasswordProvider();

          }
        ),
        ChangeNotifierProxyProvider<AuthProvider, EditProfileProvider>(
          create: (context) => EditProfileProvider(),
          update: (context, authProv, editProv) {
              if (editProv != null) {

              return editProv..recieveToken(authProv);
              }
                return EditProfileProvider();

          }
        ),
        
      
     
      ],
      builder: (context, child) => Consumer<AuthProvider>(
          builder: (context, auth, child) => MaterialApp(
                home: auth.getIsAuth() ? DashboardPage() : LoginPage(),
              )),
    );
  }
}