import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_keeper/models/meal.dart';
import 'package:meal_keeper/notifiers/selected_notifier.dart';
import 'package:meal_keeper/screens/camera_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingTop = MediaQuery.of(context).padding.top;
    final meals = Provider.of<List<Meal>>(context);
    SelectedNotifier _selectedNotifier = Provider.of<SelectedNotifier>(context);

    return Scaffold(
        appBar: _AppBar(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          paddingTop: paddingTop,
          meals: meals,
        ),
        floatingActionButton: FloatingActionButton.extended(
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
        body: Column(
          children: [
            SizedBox(height: screenHeight * 0.04),

            for (Meal meal in meals.where((element) {
              return element.date == _selectedNotifier.selectedDate;
            }).toList())
              _MealListTile(
                  meal: meal,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight)
            // for (Meal meal in meals)
          ],
        ));
  }
}

class _MealListTile extends StatelessWidget {
  final Meal meal;
  final double screenWidth;
  final double screenHeight;

  _MealListTile(
      {required this.meal,
      required this.screenWidth,
      required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.25,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02, vertical: screenHeight * 0.01),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: Colors.grey.shade300,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: screenHeight * 0.25,
                    width: screenWidth * 0.35,
                    child: Image.network(
                      '${meal.imgURL}',
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          '${meal.category}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            '${meal.date}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          children: [
                            for (String ingredient in meal.ingredients!)
                              Row(
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                            color: Colors.blue.shade200,
                                            child: Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Text('$ingredient',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: screenWidth * 0.01)
                                ],
                              ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          children: [
                            Text(
                              '${meal.calorie}',
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              'Kcal',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final double screenHeight;
  final double screenWidth;
  final double paddingTop;
  final List<Meal> meals;
  _AppBar(
      {required this.screenWidth,
      required this.screenHeight,
      required this.paddingTop,
      required this.meals});

  @override
  Size get preferredSize => Size.fromHeight(screenHeight * 0.12);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: paddingTop),
        Container(
          height: screenHeight * 0.06,
          color: Colors.green[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _DayText(day: '월'),
              _DayText(day: '화'),
              _DayText(day: '수'),
              _DayText(day: '목'),
              _DayText(day: '금'),
              _DayText(day: '토'),
              _DayText(day: '일'),
            ],
          ),
        ),
        DateIndex(screenHeight: screenHeight),
      ],
    );
  }
}

class DateIndex extends StatefulWidget {
  final double screenHeight;

  DateIndex({required this.screenHeight});

  @override
  DateIndexState createState() => DateIndexState();

  static DateIndexState? of(BuildContext context) =>
      context.findAncestorStateOfType<DateIndexState>();
}

class DateIndexState extends State<DateIndex> {
  List<String> dateList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 30; i++) {
      DateTime now = DateTime.now().subtract(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      dateList.add(formattedDate);
    }
    print(dateList);
  }

  @override
  Widget build(BuildContext context) {
    SelectedNotifier _selectedNotifier = Provider.of<SelectedNotifier>(context);
    return Container(
        height: widget.screenHeight * 0.06,
        color: Colors.green[100],
        child: ListView.builder(
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemCount: 30,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  _selectedNotifier.toggle(dateList[index]);
                },
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          dateList[index],
                          style:
                              _selectedNotifier.selectedDate == dateList[index]
                                  ? TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber)
                                  : TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                        ))));
          },
        ));
  }
}

class _DayText extends StatelessWidget {
  final day;
  _DayText({@required this.day});
  @override
  Widget build(BuildContext context) {
    return Text(
      day,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
