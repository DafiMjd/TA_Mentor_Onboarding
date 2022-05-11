class Formatter {

  static doubleToPercent(double val) {
    if (val == 0) {
      return val.toString() + " %";
    }
    double percent = val * 100;
    return percent.toStringAsFixed(1) + " %";
  }
  
}