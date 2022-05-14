import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/models/user.dart';
import 'package:ta_mentor_onboarding/providers/auth_provider.dart';
import 'package:ta_mentor_onboarding/providers/dashboard_tab_provider.dart';
import 'package:ta_mentor_onboarding/utils/constans.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';
import 'package:ta_mentor_onboarding/views/bottom_navbar.dart';
import 'package:ta_mentor_onboarding/views/dashboard_page.dart';
import 'package:ta_mentor_onboarding/views/profile/change_password.dart';
import 'package:ta_mentor_onboarding/views/profile/edit_profile.dart';
import 'package:ta_mentor_onboarding/widgets/space.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthProvider authProv;
  late DashboardTabProvider dashboardTabProv;

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    dashboardTabProv =
        Provider.of<DashboardTabProvider>(context, listen: false);
    authProv = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ORANGE_GARUDA,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // profile pic, name, etc
            Container(
              margin: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.14,
              child: Card(
                child: Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: MediaQuery.of(context).size.height * 0.14 - 20,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 15, left: 13, bottom: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(children: [
                              Text(
                                widget.user.name,
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                widget.user.jobtitle!.jobtitle_name,
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.end,
                              )
                            ]),
                            InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfile(user: widget.user))),
                              child: Row(
                                children: [
                                  Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: EDIT_PROFILE_COLOR),
                                  ),
                                  VerticalDivider(
                                    width: 15,
                                  ),
                                  Icon(
                                    Icons.edit,
                                    size: 17,
                                    color: EDIT_PROFILE_COLOR,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),

            // detail profile
            Container(
              margin: EdgeInsets.all(10),
              child: Card(
                  child: Column(
                children: [
                  // Full Name
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CARD_BORDER,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(
                            "Full Name",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            widget.user.name,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  
                  ),

                  // Job Title
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CARD_BORDER,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(
                            "Jobtitle",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            widget.user.jobtitle!.jobtitle_name,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Email
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CARD_BORDER,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(
                            "Email",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          margin: EdgeInsets.all(5),
                          child: Text(
                            widget.user.email,
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.clip,
                          ),
                        )
                      ],
                    ),
                  ),

                  // Phone Number
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CARD_BORDER,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(
                            "Phone Number",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            widget.user.phone_number,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Birth Date
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CARD_BORDER,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(
                            "Birth Date",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            widget.user.birtdate,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Gender
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CARD_BORDER,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(
                            "Gender",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            widget.user.gender,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
            ),

            // Change Password
            Container(
              margin: EdgeInsets.all(10),
              child: Card(
                child: ListTile(
                  onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()))
                      .then((value) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage()));
                  }),
                  title:
                      Text("Change Password", style: TextStyle(fontSize: 16)),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),

            // Logout
            Container(
              margin: EdgeInsets.all(10),
              child: Card(
                child: ListTile(
                  onTap: () {
                    dashboardTabProv.tab = HOME_PAGE;
                    dashboardTabProv.botNavBarIndex = 0;
                    authProv.logout();
                  },
                  title: Text("Logout",
                      style: TextStyle(fontSize: 16, color: Colors.red)),
                  trailing: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
