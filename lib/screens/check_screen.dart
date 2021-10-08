import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meal_keeper/models/meal.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meal_keeper/screens/home_screen.dart';

class CheckScreen extends StatefulWidget {
  final XFile? picture;
  final String? path;
  final List<dynamic>? recognitions;
  CheckScreen({this.picture, this.path, this.recognitions});

  @override
  _CheckScreenState createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  String dropdownValue = "아침";
  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: top),
          Image.file(File(widget.path!), height: size.height * 0.7),
          SizedBox(height: 10),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['아침', '점심', '저녁']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('감지된 물체 :  ', style: TextStyle(fontWeight: FontWeight.bold)),
              for (int i = 0; i < widget.recognitions!.length; i++)
                Text(widget.recognitions![i]['detectedClass'] + '   ')
            ],
          ),
          SizedBox(height: 20),
          Text("저장 하시겠습니까?"),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('예'),
                onPressed: () async {
                  // 이미지 저장
                  File file = File(widget.picture!.path);
                  Reference ref = FirebaseStorage.instance
                      .ref()
                      .child('meals')
                      .child('${DateTime.now()}.png');
                  UploadTask uploadTask = ref.putFile(file);
                  await uploadTask.whenComplete(() => null);
                  final downloadURL = await ref.getDownloadURL();
                  // DB에 저장
                  List<dynamic> detectedClasses = [];
                  for (int i = 0; i < widget.recognitions!.length; i++) {
                    detectedClasses
                        .add(widget.recognitions![i]['detectedClass']);
                  }
                  Meal meal = Meal(
                    category: dropdownValue,
                    ingredients: detectedClasses,
                    publishedDate: DateTime.now(),
                    imgURL: downloadURL,
                  );
                  print('식사 객체 생성 완료');
                  Map<String, dynamic> result = meal.toJson();
                  print('Map 형태로 변환 완료');
                  await FirebaseFirestore.instance
                      .collection('meals')
                      .add(result);
                  // 페이지 이동
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
              ),
              SizedBox(width: 20),
              ElevatedButton(
                child: Text('아니오'),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
