import 'package:flutter/material.dart';
import 'package:ta_mentor_onboarding/utils/status_utils.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem(
      {Key? key,
      required this.title,
      required this.description,
      required this.statusId})
      : super(key: key);

  final String title;
  final String description;
  final String statusId;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> status = STATUSES[statusId]!;
    return Card(
      child: ListTile(
        // leading: CircleAvatar(
        //   child: Padding(
        //     padding: const EdgeInsets.all(5),
        //     child: FittedBox(
        //       child: Text(title),
        //     ),
        //   ),
        // ),
        title: Text(title),
        subtitle: Text(
          description,
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
    );
  }
}
