import 'package:flutter/material.dart';

class BoundingBox extends StatelessWidget {
  final dynamic recognition;
  final double factorX;
  final double factorY;

  BoundingBox({
    required this.recognition,
    required this.factorX,
    required this.factorY,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: recognition["rect"]["x"] * factorX,
      top: recognition["rect"]["y"] * factorY,
      width: recognition["rect"]["w"] * factorX,
      height: recognition["rect"]["h"] * factorY,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.pink, width: 2.0),
        ),
        child: Text(
          "${recognition['detectedClass']} ${(recognition['confidenceInClass'] * 100).toString()}",
          style: TextStyle(
            color: Colors.pink,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
