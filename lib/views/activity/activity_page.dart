import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/models/user.dart';
import 'package:ta_mentor_onboarding/providers/activity/activity_provider.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';
import 'package:ta_mentor_onboarding/utils/formatter.dart';
import 'package:ta_mentor_onboarding/views/activity/browse_activity.dart';
import 'package:ta_mentor_onboarding/views/activity/category_page.dart';
import 'package:ta_mentor_onboarding/views/bottom_navbar.dart';
import 'package:ta_mentor_onboarding/widgets/error_alert_dialog.dart';
import 'package:ta_mentor_onboarding/widgets/loading_widget.dart';
import 'package:ta_mentor_onboarding/widgets/progress_bar.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late ActivityProvider prov;
  late List<User> users;

  @override
  void initState() {
    super.initState();

    prov = Provider.of<ActivityProvider>(context, listen: false);
    fetchUsers();
  }

  void errorfetchUsers(e) async {
    users = [];
    return showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(error: "HTTP Error", title: e.toString());
        });
  }

  void fetchUsers() async {
    prov.isFetchingData = true;

    try {
      users = await prov.fetchUsers(4);
      prov.isFetchingData = false;
    } catch (e) {
      prov.isFetchingData = false;
      return errorfetchUsers(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    prov = context.watch<ActivityProvider>();
    final ScrollController _scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ORANGE_GARUDA,
        title: Text(
          "Activity",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: (prov.isFetchingData)
          ? LoadingWidget()
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  fetchUsers();
                });
              },
              child: (users.isEmpty)
                  ? SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Text(
                          'No Data',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, i) {
                        return UsersWithProgressWidget(
                          user: users[i],
                          press: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // return BrowseActivity(
                              //   user: users[i],
                              // );
                              return CategoryPage(user: users[i],);
                            }));
                          },
                        );
                      }),
            ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class UsersWithProgressWidget extends StatelessWidget {
  const UsersWithProgressWidget(
      {Key? key, required this.user, required this.press})
      : super(key: key);

  final User user;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
          margin: EdgeInsets.all(5),
          child: Card(
            elevation: 5,
            child: ListTile(
                title: Text(user.name),
                subtitle: Text(user.finishedActivities.toString() +
                    '/' +
                    user.assignedActivities.toString() +
                    ' Activities'),
                trailing: ProgressBar(progress: user.progress)),
          )),
    );
  }
}
