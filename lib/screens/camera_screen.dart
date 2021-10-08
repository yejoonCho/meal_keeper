import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_keeper/main.dart';
import 'package:meal_keeper/screens/bounding_box.dart';
import 'package:meal_keeper/screens/check_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? cameraController;
  CameraImage? cameraImage;
  double? imgHeight;
  double? imgWidth;
  List<dynamic>? recognitions;
  bool isWorking = false;

  initCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value) {
      if (!mounted) return;
      setState(() {
        cameraController!.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  cameraImage = imageFromStream,
                  runModelOnStreamFrame()
                }
            });
      });
    });
  }

  runModelOnStreamFrame() async {
    imgHeight = cameraImage!.height + 0.0;
    imgWidth = cameraImage!.width + 0.0;
    recognitions = await Tflite.detectObjectOnFrame(
      bytesList: cameraImage!.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      model: "SSDMobileNet",
      imageHeight: cameraImage!.height,
      imageWidth: cameraImage!.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    );
    isWorking = false;
    setState(() {
      cameraImage!;
    });
  }

  Future loadModel() async {
    Tflite.close();
    try {
      String? response;
      response = await Tflite.loadModel(
          model: "assets/ssd_mobilenet.tflite",
          labels: "assets/ssd_mobilenet.txt");
      print(response!);
    } on PlatformException {
      print("Unable to Load Model");
    }
  }

  @override
  void dispose() {
    super.dispose();
    cameraController!.stopImageStream();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();
    loadModel();
    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('AppBar'),
        ),
        backgroundColor: Colors.black,
        body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              (!cameraController!.value.isInitialized)
                  ? Container()
                  : AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio * 0.4,
                      child: CameraPreview(cameraController!),
                    ),
              Positioned(
                bottom: 20,
                left: 150,
                child: ElevatedButton(
                  child: Icon(Icons.camera_alt_outlined),
                  onPressed: () async {
                    try {
                      super.dispose();
                      cameraController!.stopImageStream();
                      XFile picture = await cameraController!.takePicture();
                      final path = join(
                        (await getTemporaryDirectory()).path,
                        '${DateTime.now()}.png',
                      );
                      await picture.saveTo(path);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckScreen(
                                    picture: picture,
                                    path: path,
                                    recognitions: recognitions,
                                  )));
                    } catch (e) {
                      print('에러는?' + e.toString());
                    }
                  },
                ),
              ),
              if (recognitions != null)
                for (int i = 0; i < recognitions!.length; i++)
                  BoundingBox(
                    recognition: recognitions![i],
                    factorX: size.width,
                    factorY: imgHeight!,
                  )
            ],
          ),
        ),
      ),
    );
  }
}
