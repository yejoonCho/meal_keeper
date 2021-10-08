import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meal_keeper/models/meal.dart';
import 'package:meal_keeper/providers/DateProvider.dart';
import 'package:meal_keeper/repositories/meal_repository.dart';
import 'package:meal_keeper/screens/home_screen.dart';
import 'package:provider/provider.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  // 레파지토리
  MealRepository _mealRepository = MealRepository();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DateProvider()),
      StreamProvider<List<Meal>>(
        create: (context) => _mealRepository.fetch(),
        initialData: [],
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
