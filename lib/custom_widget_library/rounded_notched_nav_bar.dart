import 'package:flutter/material.dart';

class RoundedNotchedNavBar extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  const RoundedNotchedNavBar({
    super.key,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
        clipper: NavBarClipper(),
        child: Container(
          height: 80,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: borderColor, width: 1),
          ),
        ),
      ),
    );
  }
}

class NavBarClipper extends CustomClipper<Path> {
  Path _getCurvedPath(Size size) {
    double h = size.height;
    double w = size.width;
    final path = Path();

    double radius = 38;
    double upRad = 16;

    // (0,0) -> default point, p1
    path.lineTo(0, h); // point p2
    path.lineTo(w, h); // point p3
    path.lineTo(w, 0); // point p4
    path.lineTo(w * 0.5 + radius + 5 * upRad, 0);
    path.quadraticBezierTo(
      w * 0.5 + radius + upRad * 0.8,
      radius * 0.2,
      w * 0.5 + radius,
      radius * 0.7,
    );
    path.quadraticBezierTo(w * 0.5, h * 0.85, w * 0.5 - radius, radius * 0.7);
    path.quadraticBezierTo(
      w * 0.5 - radius - upRad * 0.8,
      radius * 0.2,
      w * 0.5 - radius - 5 * upRad,
      0,
    );

    path.close(); // close the loop to point p1
    // or
    // path.lineTo(0, 0); // close the loop to point p1
    return path;
  }

  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Path path = _getCurvedPath(size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
