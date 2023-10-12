class DateUtils {
  static int convertDateTimeToLong(DateTime dateTime) {
    // Convert the DateTime to a Unix timestamp (long format) in seconds
    int unixTimestamp = dateTime.millisecondsSinceEpoch ~/ 1000;
    return unixTimestamp;
  }
}
