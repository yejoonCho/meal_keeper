import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class SelectedNotifier extends ChangeNotifier {
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void toggle(String date) {
    selectedDate = date;
    notifyListeners();
  }
}
