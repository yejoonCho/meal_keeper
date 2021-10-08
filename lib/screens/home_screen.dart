import 'package:flutter/material.dart';
import 'package:meal_keeper/models/meal.dart';
import 'package:meal_keeper/providers/DateProvider.dart';
import 'package:meal_keeper/screens/camera_screen.dart';
import 'package:meal_keeper/screens/meal_list_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double top = MediaQuery.of(context).padding.top;
    final meals = Provider.of<List<Meal>>(context);

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            icon: Icon(Icons.add),
            label: Text(
              '카메라로 식단 촬영하기',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CameraScreen()));
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            icon: Icon(Icons.add),
            label: Text(
              '갤러리에서 식단 가져오기',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: top),
          Container(
            height: size.height * 0.06,
            color: Colors.green[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DayText(day: '월'),
                DayText(day: '화'),
                DayText(day: '수'),
                DayText(day: '목'),
                DayText(day: '금'),
                DayText(day: '토'),
                DayText(day: '일'),
              ],
            ),
          ),
          Container(
              height: size.height * 0.06,
              color: Colors.green[100],
              child: ListView.builder(
                reverse: true,
                scrollDirection: Axis.horizontal,
                itemCount: 30,
                itemBuilder: (context, index) {
                  final dateProvider = DateProvider();
                  return GestureDetector(
                    onTap: () {
                      print(dateProvider.dateList[index] + '일');
                    },
                    child: DayText(
                        day: dateProvider.monthList[index] +
                            "월 " +
                            dateProvider.dateList[index] +
                            "일   "),
                  );
                },
              )),
          SizedBox(height: 30),
          for (Meal meal in meals) MealListTile(meal: meal)
        ],
      ),
    );
  }
}

class DayText extends StatelessWidget {
  final day;
  DayText({@required this.day});
  @override
  Widget build(BuildContext context) {
    return Text(
      day,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
