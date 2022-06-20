import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/models/activity_owned.dart';
import 'package:ta_mentor_onboarding/models/status_menu.dart';
import 'package:ta_mentor_onboarding/models/user.dart';
import 'package:ta_mentor_onboarding/providers/activity/browse_activity_provider.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';
import 'package:ta_mentor_onboarding/views/activity/activity_item.dart';
import 'package:ta_mentor_onboarding/views/activity/top_nav_bar.dart';
import 'package:ta_mentor_onboarding/widgets/error_alert_dialog.dart';
import 'package:ta_mentor_onboarding/widgets/loading_widget.dart';
import 'package:ta_mentor_onboarding/widgets/space.dart';

class BrowseActivity extends StatefulWidget {
  const BrowseActivity({Key? key, required this.user, required this.cat_id}) : super(key: key);

  final User user;
  final int cat_id;

  @override
  State<BrowseActivity> createState() => _BrowseActivityState();
}

class _BrowseActivityState extends State<BrowseActivity> {
  late BrowseActivityProvider prov;
  late List<StatusMenu> menus;
  late List<ActivityOwned> activitiesOwned;
  late String curMenuId;

  @override
  void initState() {
    super.initState();
    prov = Provider.of<BrowseActivityProvider>(context, listen: false);

    curMenuId = 'all_activity';

    initMenu();
    fetchActivities(widget.user.email, curMenuId);
  }

  void initMenu() {
    prov.menus = _changeMenuState(prov.menus, 0);
  }

  void errorFetchActivities(e) async {
    activitiesOwned = [];
    return showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(error: e.toString(), title: "HTTP Error");
        });
  }

  void fetchActivities(String email, String status) async {
    prov.isFetchingData = true;

    String allActId = context.read<BrowseActivityProvider>().menus[0].id;

    try {
      if (status == allActId) {
        activitiesOwned = await prov.fetchActOwnedByUser(email, widget.cat_id);
      } else {
        print(status);
        activitiesOwned = await prov.fetchActOwnedByUserByStatus(email, widget.cat_id, status);
      }
      prov.isFetchingData = false;
    } catch (e) {
      prov.isFetchingData = false;
      errorFetchActivities(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    BrowseActivityProvider prov = context.watch<BrowseActivityProvider>();

    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: ORANGE_GARUDA,
          title: Text(widget.user.name + '\'s Activities')),
      body: Column(mainAxisSize: MainAxisSize.min,  children: [
        _topNavBarBuilder(),
        Space.space(),
        (prov.isFetchingData)
            ? LoadingWidget()
            :
            // activity card

            RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    fetchActivities(widget.user.email, curMenuId);
                  });
                },
                child: (activitiesOwned.isEmpty)
                    ? SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Text(
                            'No Activity',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: activitiesOwned.length,
                        itemBuilder: (context, i) {
                          return ActivityItem(
                            activityOwned: activitiesOwned[i],
                          );
                        }),
              ),
      ]),
    );
  }

  Container _topNavBarBuilder() {
    List<StatusMenu> menu = context.read<BrowseActivityProvider>().menus;
    return Container(
        margin: EdgeInsets.all(15),
        height: 40,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: menu.length,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  menu = _changeMenuState(menu, i);
                  prov.menus = menu;
                  fetchActivities(widget.user.email, menu[i].id);
                },
                child: TopNavBar(
                  menuIndex: i,
                ),
              );
            }));
  }

  List<StatusMenu> _changeMenuState(List<StatusMenu> menu, selectedIndex) {
    curMenuId = menu[selectedIndex].id;
    for (int i = 0; i < menu.length; i++) {
      if (i == selectedIndex) {
        menu[i].selected = true;
      } else {
        menu[i].selected = false;
      }
    }
    return menu;
  }
}
