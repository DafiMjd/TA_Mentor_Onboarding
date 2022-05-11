import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:ta_mentor_onboarding/utils/custom_colors.dart';
import 'package:ta_mentor_onboarding/utils/formatter.dart';
import 'package:ta_mentor_onboarding/widgets/space.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar(
      {Key? key,
      required this.progress,})
      : super(key: key);

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: 
        LinearPercentIndicator(
          alignment: MainAxisAlignment.center,
          animation: true,
          lineHeight: 20.0,
          animationDuration: 2500,
          percent: progress,
          center: Text(Formatter.doubleToPercent(progress),
              style: TextStyle(
                color: Colors.white,
              )),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: PROGRESS_BAR,
        ),
      
    );
  }
}
