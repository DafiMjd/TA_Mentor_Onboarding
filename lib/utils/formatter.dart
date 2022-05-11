class Formatter {

  static doubleToPercent(double val) {
    if (val == 0) {
      return val.toString() + " %";
    }
    double percent = val * 100;
    return percent.toStringAsFixed(1) + " %";
  }

  static Map<String, dynamic> dateFormatter(DateTime start, DateTime end) {
    var difference = end.difference(start);
    var difDays = difference.inDays;


    // getting hour diff
    start = start.add(Duration(days: difDays));
    var difference2 = end.difference(start);
    var difHour = difference2.inHours;

    // getting minute diff
    start = start.add(Duration(hours: difHour));
    var difference3 = end.difference(start);
    var difMin = difference3.inMinutes;

    String difString = difDays.toString() + ' D ' + difHour.toString() + ' H ' + difMin.toString() + ' M';


    Map<String, dynamic> difReturn = {'difference': difference, 'difString': difString};

    return difReturn;
  }
  
}