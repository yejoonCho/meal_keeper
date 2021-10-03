import 'package:flutter/material.dart';

class DateProvider extends ChangeNotifier {
  List<String> monthList = [];
  List<String> dateList = [];

  DateProvider() {
    fetch();
  }

  fetch() {
    for (int i = 0; i < 30; i++) {
      String month =
          DateTime.now().subtract(Duration(days: i)).month.toString();
      monthList.add(month);
      String date = DateTime.now().subtract(Duration(days: i)).day.toString();
      dateList.add(date);
    }
  }
}
