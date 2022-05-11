import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/models/status_menu.dart';
import 'package:ta_mentor_onboarding/providers/activity/browse_activity_provider.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({
    Key? key,
    required this.menuIndex,
  }) : super(key: key);

  final int menuIndex;

  @override
  Widget build(BuildContext context) {
    StatusMenu menu = context.read<BrowseActivityProvider>().menus.elementAt(menuIndex);
    bool selected = menu.selected;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(

      color: (selected) ? BROWN_GARUDA : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: BROWN_GARUDA)),
      child: Center(
        child: Text(menu.statusName,
            style: TextStyle(
                fontSize: 15,
                color: (selected) ? Colors.white : BROWN_GARUDA,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}