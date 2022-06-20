import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/models/user.dart';
import 'package:ta_mentor_onboarding/providers/leaderboard/leaderboard_provider.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';
import 'package:ta_mentor_onboarding/views/bottom_navbar.dart';
import 'package:ta_mentor_onboarding/widgets/error_alert_dialog.dart';
import 'package:ta_mentor_onboarding/widgets/loading_widget.dart';
import 'package:ta_mentor_onboarding/widgets/progress_bar.dart';

class LeaderboardPage extends StatefulWidget {
  LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late LeaderboardProvider prov;

  late List<User> users;

  @override
  void initState() {
    super.initState();

    prov = Provider.of<LeaderboardProvider>(context, listen: false);
    fetchUsers();
  }

  void errorfetchUsers(e) async {
    users = [];
    return showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(error: e.toString(), title: "HTTP Error");
        });
  }

  void fetchUsers() async {
    prov.isFetchingData = true;

    try {
      users = await prov.fetchUsers(4);
      users.sort((a, b) => b.progress.compareTo(a.progress));

      prov.isFetchingData = false;
    } catch (e) {
      prov.isFetchingData = false;
      return errorfetchUsers(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    prov = context.watch<LeaderboardProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: ORANGE_GARUDA,
        foregroundColor: Colors.black,
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
                        return LeaderboardTile(rank: i, user: users[i]);
                      }),
            ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile({Key? key, required this.rank, required this.user})
      : super(key: key);

  final User user;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          margin: EdgeInsets.all(5),
          child: Card(
            elevation: 5,
            child: ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_border_purple500_rounded,
                      color: getStarColor(rank),
                    ),
                    Text((rank+1).toString()),
                  ],
                ),
                title: Text(user.name),
                trailing: ProgressBar(progress: user.progress)),
          )),
    );
  }

  getStarColor(id) {
    if (id == 0) {
      return BLUE_1ST;
    } else if (id == 1) {
      return SILVER_2ND;
    } else if (id == 2) {
      return BROWN_3RD;
    } else {
      return GREY_4TH;
    }
  }
}
