import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_keeper/main.dart';
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
    cameraController = CameraController(cameras![0], ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.yuv420);
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

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (recognitions == null) return [];
    if (imgHeight == null || imgWidth == null) return [];

    double factorX = screen.width;
    double factorY = imgHeight!;
    return recognitions!.map((result) {
      return Positioned(
        left: result["rect"]["x"] * factorX,
        top: result["rect"]["y"] * factorY,
        width: result["rect"]["w"] * factorX,
        height: result["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['detectedClass']} ${(result['confidenceInClass'] * 100).toString()}",
            style: TextStyle(
              color: Colors.pink,
              fontSize: 16,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildrenWidgets = [];
    stackChildrenWidgets.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        height: size.height - 100,
        child: (!cameraController!.value.isInitialized)
            ? Container()
            : AspectRatio(
                aspectRatio: cameraController!.value.aspectRatio,
                child: CameraPreview(cameraController!),
              )));
    if (cameraImage != null) {
      stackChildrenWidgets.addAll(displayBoxesAroundRecognizedObjects(size));
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(top: 50),
          color: Colors.black,
          child: Stack(
            children: stackChildrenWidgets,
          ),
        ),
      ),
    );
  }
}
