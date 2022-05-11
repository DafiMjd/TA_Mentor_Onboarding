import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';
import 'package:ta_mentor_onboarding/views/bottom_navbar.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage(
      {Key? key, required this.userProgress})
      : super(key: key);

  final double userProgress;

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ORANGE_GARUDA,
        title: Text(
          "Activity",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
