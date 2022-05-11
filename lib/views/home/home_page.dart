import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/models/user.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';
import 'package:ta_mentor_onboarding/views/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key, required this.user }) : super(key: key);

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 5),
      child: AppBar(
        elevation: 0,
        backgroundColor: ORANGE_GARUDA,
        flexibleSpace: Container(
          height: MediaQuery.of(context).size.height / 5,
          margin: EdgeInsets.only(
            top: 30,
            bottom: 30,
            left: 20,
          ),
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text("Selamat Datang!",
                    style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
              ),
              Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(widget.user.name,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(widget.user.jobtitle.jobtitle_name,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
    
      body: Stack(
      children: [
        // background
        Container(
          color: ORANGE_GARUDA,
        ),
        // white circular background
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
        ),
        //* Content

        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Text("Explore",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ),

                ],
            ),
          ),
        ),

        // Pengenalan Perusahaan
      ],
    ),
      bottomNavigationBar: BottomNavBar()
    );
  }
}