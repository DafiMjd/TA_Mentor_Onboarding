import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/providers/activity/activity_detail_provider.dart';
import 'package:ta_mentor_onboarding/providers/activity/activity_provider.dart';
import 'package:ta_mentor_onboarding/providers/activity/browse_activity_provider.dart';
import 'package:ta_mentor_onboarding/providers/auth_provider.dart';
import 'package:ta_mentor_onboarding/providers/dashboard_tab_provider.dart';
import 'package:ta_mentor_onboarding/providers/home/home_provider.dart';
import 'package:ta_mentor_onboarding/providers/leaderboard/leaderboard_provider.dart';
import 'package:ta_mentor_onboarding/providers/profile/change_password_provider.dart';
import 'package:ta_mentor_onboarding/providers/profile/edit_profile_provider.dart';
import 'package:ta_mentor_onboarding/providers/profile/profile_provider.dart';
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
        ChangeNotifierProxyProvider<AuthProvider, DashboardTabProvider>(
            create: (context) => DashboardTabProvider(),
            update: (context, authProv, dashPorv) {
              if (dashPorv != null) {
                return dashPorv..recieveToken(authProv);
              }
              return DashboardTabProvider();
            }),
        ChangeNotifierProxyProvider<AuthProvider, ChangePasswordProvider>(
            create: (context) => ChangePasswordProvider(),
            update: (context, authProv, dashPorv) {
              if (dashPorv != null) {
                return dashPorv..recieveToken(authProv);
              }
              return ChangePasswordProvider();
            }),
        ChangeNotifierProxyProvider<AuthProvider, EditProfileProvider>(
            create: (context) => EditProfileProvider(),
            update: (context, authProv, editProv) {
              if (editProv != null) {
                return editProv..recieveToken(authProv);
              }
              return EditProfileProvider();
            }),
        ChangeNotifierProxyProvider<AuthProvider, HomeProvider>(
            create: (context) => HomeProvider(),
            update: (context, authProv, homeProv) {
              if (homeProv != null) {
                return homeProv..recieveToken(authProv);
              }
              return HomeProvider();
            }),
        ChangeNotifierProxyProvider<AuthProvider, ActivityProvider>(
            create: (context) => ActivityProvider(),
            update: (context, authProv, actProv) {
              if (actProv != null) {
                return actProv..recieveToken(authProv);
              }
              return ActivityProvider();
            }),
        ChangeNotifierProxyProvider<AuthProvider, BrowseActivityProvider>(
            create: (context) => BrowseActivityProvider(),
            update: (context, authProv, browseProv) {
              if (browseProv != null) {
                return browseProv..recieveToken(authProv);
              }
              return BrowseActivityProvider();
            }),
        ChangeNotifierProxyProvider<AuthProvider, ActivityDetailProvider>(
            create: (context) => ActivityDetailProvider(),
            update: (context, authProv, detailProv) {
              if (detailProv != null) {
                return detailProv..recieveToken(authProv);
              }
              return ActivityDetailProvider();
            }),
        ChangeNotifierProxyProvider<AuthProvider, LeaderboardProvider>(
            create: (context) => LeaderboardProvider(),
            update: (context, authProv, leaderboardProv) {
              if (leaderboardProv != null) {
                return leaderboardProv..recieveToken(authProv);
              }
              return LeaderboardProvider();
            }),
        ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
            create: (context) => ProfileProvider(),
            update: (context, authProv, profProv) {
              if (profProv != null) {
                return profProv..recieveToken(authProv);
              }
              return ProfileProvider();
            }),

      ],
      builder: (context, child) => Consumer<AuthProvider>(
          builder: (context, auth, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                home: auth.getIsAuth() ? DashboardPage() : LoginPage(),
              )),
    );
  }
}
