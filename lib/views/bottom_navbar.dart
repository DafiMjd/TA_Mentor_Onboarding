import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/providers/dashboard_tab_provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DashboardTabProvider dashboardTabProvider =
        context.watch<DashboardTabProvider>();
    return BottomNavigationBar(
      currentIndex: dashboardTabProvider.botNavBarIndex,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), label: "", backgroundColor: Colors.white),
        BottomNavigationBarItem(
            icon: Icon(Icons.task), label: "", backgroundColor: Colors.white),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: "",
            backgroundColor: Colors.white),
      ],
      onTap: (index) {
        dashboardTabProvider.botNavBarIndex = index;
        dashboardTabProvider.tab = dashboardTabProvider.botNavBarIndex;
      },
    );
  }
}
