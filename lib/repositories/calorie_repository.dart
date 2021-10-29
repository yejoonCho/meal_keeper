import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_keeper/models/calorie.dart';

class CalorieRepository {
  Future<List<Calorie>> fetch() async {
    final String response = await rootBundle.loadString('assets/calories.json');
    List datas = json.decode(response);
    final List<Calorie> calories = [];
    for (int i = 0; i < datas.length; i++) {
      calories.add(Calorie.fromJson(datas[i]));
    }
    return calories;
  }
}
