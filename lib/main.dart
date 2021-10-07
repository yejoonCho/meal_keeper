import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:meal_keeper/providers/DateProvider.dart';
import 'package:meal_keeper/screens/home_screen.dart';
import 'package:provider/provider.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DateProvider()),
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
