import 'package:flutter/material.dart';

/// Clip widget in oval shape at right side
class OvalLeftBorderClipper extends CustomClipper<Path> {
  OvalLeftBorderClipper({
    required this.curveHeight,
  });

  final double curveHeight;

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(3*curveHeight/4, 0);
    path.lineTo(curveHeight/1.5, size.height/4);
   // path.quadraticBezierTo(curveHeight/4, y1, x2, y2)
   // path.quadraticBezierTo(0, size.height / 4, curveHeight/2, size.height / 2);
    // path.quadraticBezierTo(
    //     0, size.height - (size.height / 4), curveHeight, size.height);
  
  //path.quadraticBezierTo(0, size.height/2, x2, y2)
    path.lineTo(curveHeight/1.5, 3*size.height/4);
    path.lineTo(curveHeight, size.height);

    path.lineTo(curveHeight, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}