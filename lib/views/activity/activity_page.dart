import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/models/user.dart';
import 'package:ta_mentor_onboarding/providers/activity/activity_provider.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';
import 'package:ta_mentor_onboarding/utils/formatter.dart';
import 'package:ta_mentor_onboarding/views/activity/browse_activity_page.dart';
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

  void fetchUsers() async {
    prov.isFetchingData = true;

    try {
      users = await prov.fetchUsers(4);
      prov.isFetchingData = false;
    } catch (e) {
      users = [];
      prov.isFetchingData = false;
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(error: e.toString(), title: 'HTTP Error');
          });
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
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, i) {
                    return UsersWithProgressWidget(
                      name: users[i].name,
                      press: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BrowseActivityPage(
                            user: users[i],
                          );
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
      {Key? key, required this.name, required this.press})
      : super(key: key);

  final String name;
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
                title: Text(name),
                subtitle: Text('10/50 Activities'),
                trailing: ProgressBar(progress: 0.5)),
          )),
    );
  }
}
