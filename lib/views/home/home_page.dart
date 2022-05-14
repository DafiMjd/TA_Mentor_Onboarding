import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/models/activity_owned.dart';
import 'package:ta_mentor_onboarding/models/user.dart';
import 'package:ta_mentor_onboarding/providers/home/home_provider.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';
import 'package:ta_mentor_onboarding/views/bottom_navbar.dart';
import 'package:ta_mentor_onboarding/views/activity/activity_item.dart';
import 'package:ta_mentor_onboarding/widgets/loading_widget.dart';
import 'package:ta_mentor_onboarding/widgets/space.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeProvider prov;
  late List<ActivityOwned> activitiesOwned;

  @override
  void initState() {
    super.initState();
    prov = Provider.of<HomeProvider>(context, listen: false);

    fetchActivities();
  }

  void errorFetchingActivities(e) async {
    activitiesOwned = [];
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("HTTP Error"),
            content: Text("$e"),
            actions: [
              TextButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: Text("okay"))
            ],
          );
        });
  }

  void fetchActivities() async {
    prov.isFetchingData = true;

    try {
      activitiesOwned = await prov.fetchActOwnedByStatus('submitted');

      prov.isFetchingData = false;
    } catch (e) {
      prov.isFetchingData = false;
      errorFetchingActivities(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    prov = context.watch<HomeProvider>();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height / 5),
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
                        child: Text(widget.user.jobtitle!.jobtitle_name,
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
                      child: Text("Need to be validated",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w400)),
                    ),
                    Space.space(),
                    (prov.isFetchingData)
                        ? LoadingWidget()
                        : RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                fetchActivities();
                              });
                            },
                            child: (activitiesOwned.isEmpty)
                                ? SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
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
                  ],
                ),
              ),
            ),

            // Pengenalan Perusahaan
          ],
        ),
        bottomNavigationBar: BottomNavBar());
  }
}
