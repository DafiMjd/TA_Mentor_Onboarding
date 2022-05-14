import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ta_mentor_onboarding/models/activity_owned.dart';
import 'package:ta_mentor_onboarding/providers/activity/activity_detail_provider.dart';
import 'package:ta_mentor_onboarding/utils/constans.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';
import 'package:ta_mentor_onboarding/utils/formatter.dart';
import 'package:ta_mentor_onboarding/utils/status_utils.dart';
import 'package:ta_mentor_onboarding/views/dashboard_page.dart';
import 'package:ta_mentor_onboarding/widgets/error_alert_dialog.dart';
import 'package:ta_mentor_onboarding/widgets/loading_widget.dart';
import 'package:ta_mentor_onboarding/widgets/space.dart';

class ActivityDetail extends StatefulWidget {
  ActivityDetail({Key? key, required this.actOwnedId}) : super(key: key);

  int actOwnedId;

  @override
  State<ActivityDetail> createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  late ActivityDetailProvider prov;
  late ActivityOwned actOwned;

  @override
  void initState() {
    super.initState();
    prov = Provider.of<ActivityDetailProvider>(context, listen: false);
    _fetchActOwned(widget.actOwnedId);
  }

  @override
  Widget build(BuildContext context) {
    prov = context.watch<ActivityDetailProvider>();
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: ORANGE_GARUDA,
        title: Text(
          'Detail Activity',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _fetchActOwned(actOwned.id);
          });
        },
        child: (prov.isFetchingData)
            ? LoadingWidget()
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ActivitySummaryCard(actOwned: actOwned),
                        Space.space(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: (actOwned.status == 'submitted')
                                  ? () {
                                      _editActOwnedStatus(actOwned.id,
                                          actOwned.user.email, 'rejected');
                                    }
                                  : () {},
                              child: Text('Reject'),
                              style: ElevatedButton.styleFrom(
                                  primary: (actOwned.status == 'submitted')
                                      ? Colors.red
                                      : Colors.red[200]),
                            ),
                            ElevatedButton(
                              onPressed: (actOwned.status == 'submitted')
                                  ? () {
                                      _editActOwnedStatus(actOwned.id,
                                          actOwned.user.email, 'completed');
                                      _editUserFinishedAct(actOwned.user.email,
                                          actOwned.user.finishedActivities + 1);

                                      if (actOwned.user.assignedActivities !=
                                          0) {
                                        var progress = (actOwned
                                                    .user.finishedActivities +
                                                1) /
                                            actOwned.user.assignedActivities;

                                        _editUserProgress(
                                            actOwned.user.email, progress);
                                      }
                                    }
                                  : () {},
                              child: Text('Validate'),
                              style: ElevatedButton.styleFrom(
                                  primary: (actOwned.status == 'submitted')
                                      ? Colors.blue
                                      : Colors.blue[200]),
                            ),
                          ],
                        ),
                        Space.space(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: (actOwned.status == 'rejected')
                                  ? () {
                                      _editActOwnedStatus(actOwned.id,
                                          actOwned.user.email, 'submitted');
                                    }
                                  : () {},
                              child: Text('Back to submitted'),
                              style: ElevatedButton.styleFrom(
                                  primary: (actOwned.status == 'rejected')
                                      ? Colors.yellow
                                      : Colors.yellow[200]),
                            ),
                            ElevatedButton(
                              onPressed: (actOwned.status == 'completed')
                                  ? () {
                                      _editActOwnedStatus(actOwned.id,
                                          actOwned.user.email, 'submitted');

                                      _editUserFinishedAct(actOwned.user.email,
                                          actOwned.user.finishedActivities - 1);

                                      if (actOwned.user.assignedActivities !=
                                          0) {
                                        var progress = (actOwned
                                                    .user.finishedActivities -
                                                1) /
                                            actOwned.user.assignedActivities;

                                        _editUserProgress(
                                            actOwned.user.email, progress);
                                      }
                                    }
                                  : () {},
                              child: Text('Back to submitted'),
                              style: ElevatedButton.styleFrom(
                                  primary: (actOwned.status == 'completed')
                                      ? Colors.brown
                                      : Colors.brown[200]),
                            ),
                          ],
                        ),
                        Space.doubleSpace(),
                        ActivityNoteCard(note: actOwned.activity_note),
                      ],
                    )),
              ),
      ),
    );
  }

  void _errorEditActOwnedStatus(e) async {
    return showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(error: e.toString(), title: "HTTP Error");
        });
  }

  void _fetchActOwned(int id) async {
    prov.isFetchingData = true;

    try {
      actOwned = await prov.fetchActOwnedById(id);
      prov.isFetchingData = false;
    } catch (e) {
      prov.isFetchingData = false;
      return _errorEditActOwnedStatus(e);
    }
  }

  void _editActOwnedStatus(int id, String email, String status) async {
    prov.isFetchingData = true;

    try {
      actOwned = await prov.editActOwnedStatus(id, email, status);
      prov.isFetchingData = false;
    } catch (e) {
      prov.isFetchingData = false;
      return _errorEditActOwnedStatus(e);
    }
  }

  void _editUserFinishedAct(String email, int finishedAct) async {
    prov.isFetchingData = true;

    try {
      await prov.editUserFinishedAct(email, finishedAct);
      prov.isFetchingData = false;
    } catch (e) {
      prov.isFetchingData = false;
      return _errorEditActOwnedStatus(e);
    }
  }

  void _editUserProgress(String email, double progress) async {
    prov.isFetchingData = true;

    try {
      await prov.editUserProgress(email, progress);
      prov.isFetchingData = false;
    } catch (e) {
      prov.isFetchingData = false;
      return _errorEditActOwnedStatus(e);
    }
  }
}

class ActivitySummaryCard extends StatelessWidget {
  const ActivitySummaryCard({Key? key, required this.actOwned})
      : super(key: key);

  final ActivityOwned actOwned;

  @override
  Widget build(BuildContext context) {
    // final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    final DateFormat formatter = DateFormat('EEE, d MMM, ' 'yyyy HH:mm');
    var startDate = formatter.format(actOwned.start_date);
    var dueDate = formatter.format(actOwned.end_date);

    Map<String, dynamic> timeRemaining =
        Formatter.dateFormatter(actOwned.start_date, actOwned.end_date);
    Map<String, dynamic> timeConsumed =
        Formatter.dateFormatter(actOwned.start_date, DateTime.now());

    return Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    actOwned.user.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: STATUSES[actOwned.status]!['color'],
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: 86,
                    height: 16,
                    child: Text(
                      STATUSES[actOwned.status]!['title'],
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 10),
                color: CARD_BORDER,
                height: 1,
              ),
              Text(
                actOwned.activity.activity_name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Space.space(),
              Row(children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Text("Start Date:", style: TextStyle(fontSize: 17))),
                Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Text(startDate, style: TextStyle(fontSize: 17))),
              ]),
              Space.space(),
              Row(children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Text("Due Date:", style: TextStyle(fontSize: 17))),
                Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Text(dueDate, style: TextStyle(fontSize: 17))),
              ]),
              Space.space(),
              Row(children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text("Time Remaining:",
                        style: TextStyle(fontSize: 17))),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                      (timeRemaining['difference'].isNegative)
                          ? 'Late ' + timeRemaining['difString']
                          : timeRemaining['difString'],
                      style: TextStyle(
                          fontSize: 17,
                          color: (timeRemaining['difference'].isNegative)
                              ? Colors.red
                              : Colors.black)),
                ),
              ]),
              Space.space(),
              Row(children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child:
                        Text("Time Consumed:", style: TextStyle(fontSize: 17))),
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(timeConsumed['difString'],
                        style: TextStyle(fontSize: 17))),
              ]),
            ],
          ),
        ));
  }
}

class ActivityNoteCard extends StatelessWidget {
  const ActivityNoteCard({Key? key, required this.note}) : super(key: key);

  final String note;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Activity Note",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Space.space(),
        Card(
          child: Container(
            child: TextFormField(
              enabled: false,
              maxLines: 2,
              initialValue: (note == null) ? '' : note,
              decoration: const InputDecoration(
                  labelText: "Notes and comments from the employee"),
            ),
          ),
        )
      ],
    );
  }
}
