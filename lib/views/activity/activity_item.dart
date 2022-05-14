import 'package:flutter/material.dart';
import 'package:ta_mentor_onboarding/models/activity_owned.dart';
import 'package:ta_mentor_onboarding/utils/status_utils.dart';
import 'package:ta_mentor_onboarding/views/activity/activity_detail.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem({Key? key, required this.activityOwned}) : super(key: key);

  final ActivityOwned activityOwned;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> status = STATUSES[activityOwned.status]!;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ActivityDetail(
                      actOwnedId: activityOwned.id,
                    )));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: Card(
          elevation: 5,
          child: ListTile(
            // leading: CircleAvatar(
            //   child: Padding(
            //     padding: const EdgeInsets.all(5),
            //     child: FittedBox(
            //       child: Text(title),
            //     ),
            //   ),
            // ),
            title: Text(activityOwned.activity.activity_name),
            subtitle: Text(
              activityOwned.activity.activity_description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: status['color'],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              width: 86,
              height: 16,
              child: Text(
                status['title'],
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
