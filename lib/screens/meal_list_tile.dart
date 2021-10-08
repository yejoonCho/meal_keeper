import 'package:flutter/material.dart';
import 'package:meal_keeper/models/meal.dart';

class MealListTile extends StatelessWidget {
  final Meal meal;
  MealListTile({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            '${meal.imgURL}',
            height: 120,
          ),
          Column(
            children: [
              Text(
                '${meal.category}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 10),
              Text('${meal.date}'),
              SizedBox(height: 10),
              Text('${meal.ingredients}')
            ],
          ),
        ],
      ),
    );
  }
}
