import 'package:flutter/material.dart';

class TimeUtils {
  static String getFormattedtime(
      {required BuildContext context, required DateTime time}) {
    final timeFor = DateTime.fromMillisecondsSinceEpoch(
        int.parse(time.millisecondsSinceEpoch.toString()));
    return TimeOfDay.fromDateTime(timeFor).format(context);
  }
}
