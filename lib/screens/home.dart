import 'package:flutter/material.dart';
import 'package:meal_keeper/providers/DateProvider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double top = MediaQuery.of(context).padding.top;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text(
          '식단 추가',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {},
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
