import 'package:flutter/material.dart';
import 'dart:math';

class WavyAnimatedProgress extends StatefulWidget {
  const WavyAnimatedProgress({super.key});

  @override
  State<WavyAnimatedProgress> createState() => _WavyAnimatedProgressState();
}

class _WavyAnimatedProgressState extends State<WavyAnimatedProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 300).animate(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;
    // TODO: implement build
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              left: _animation.value - 800,
              bottom: -400,
              child: ClipOval(
                child: Container(
                  height: 500,
                  width: screenWidth + 1000,
                  decoration: BoxDecoration(color: Color(0xFFA0B2D1)),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned(
              left: _animation.value - 400,
              bottom: -400,
              child: ClipOval(
                child: Container(
                  height: 500,
                  width: screenWidth + 1000,
                  decoration: BoxDecoration(color: Color(0xFF6288CA)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';

class WaterWave extends StatefulWidget {
  final double? height;
  final double? width;
  final double? fillFraction;
  final double? fillFractionCopy;
  final VoidCallback? updateCopy;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final Widget? child;
  const WaterWave({
    super.key,
    this.child,
    this.height,
    this.width,
    this.fillFraction,
    this.fillFractionCopy,
    this.padding,
    this.margin,
    this.decoration,
    this.updateCopy,
  });

  @override
  State<WaterWave> createState() => _WaterWaveState();
}

class _WaterWaveState extends State<WaterWave>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late BorderRadiusGeometry _painterRadius;
  late double _fillFraction;
  late double _fillFractionCopy;

  @override
  void initState() {
    super.initState();
    _painterRadius =
    ((widget.decoration != null && widget.decoration?.borderRadius != null)
        ? widget.decoration?.borderRadius
        : BorderRadius.circular(0))!;

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    )..repeat();

    _fillFraction = widget.fillFraction ?? 0.3;
    if (_fillFraction > 1) _fillFraction = 1;
    if (_fillFraction < 0) _fillFraction = 0;
    _fillFractionCopy = widget.fillFractionCopy ?? 0.3;
    if (_fillFractionCopy > 1) _fillFractionCopy = 1;
    if (_fillFractionCopy < 0) _fillFractionCopy = 0;

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;
        // print('////////// max-height: $maxHeight //////////');
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Container(
              // width: widget.width,
              // height: widget.height,
              margin: widget.margin,
              padding: widget.padding,
              // padding: EdgeInsetsGeometry.symmetric(
              //   // horizontal: 16,
              //   vertical: 16,
              // ),
              decoration: widget.decoration,
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(16),
              //   border: BoxBorder.all(color: Color(0xFFE1E9FF), width: 1),
              // ),
              child: ClipRRect(
                borderRadius: _painterRadius,
                child: TweenAnimationBuilder(
                    tween: Tween<double>(
                      begin: _fillFractionCopy,
                      end: _fillFraction,
                    ),
                    onEnd: () {
                      setState(() {
                        _fillFractionCopy = _fillFraction;
                        widget.updateCopy?.call();
                      });
                    },
                    duration: Duration(seconds: 2),
                    curve: Curves.easeInOut,

                    builder: (context, value, child) {
                      return Stack(
                        children: [
                          CustomPaint(
                            painter: WavePainter(
                              animationValue: controller.value,
                              color1: Color(0xFFDEECF4),
                              color2: Color(0xFFBCDCEF),
                              shift: 1.2,
                              fillFraction: value,
                            ),
                            size: Size(maxWidth, widget.height ?? 130),
                          ),
                          CustomPaint(
                            painter: WavePainter(
                              animationValue: controller.value,
                              color1: Color(0xFFBCDCEF),
                              color2: Color(0xFF3FB4E8),
                              shift: 0,
                              fillFraction: value,
                            ),
                            size: Size(maxWidth, widget.height ?? 130),
                          ),
                          ?widget.child,
                        ],
                      );
                    }
                ),


              ),
            );
          },
        );
        // Stack(
        //   children: [
        //     CustomPaint(
        //       painter: WavePainter(animationValue: controller.value,
        //         color1: Color(0xFFDEECF4),
        //         color2: Color(0xFFBCDCEF),
        //         shift: 1.2,),
        //       // size: Size(screenWidth, 130),
        //     ),
        //     CustomPaint(
        //       painter: WavePainter(
        //         animationValue: controller.value,
        //         color1: Color(0xFFBCDCEF),
        //         color2: Color(0xFF3FB4E8),
        //         shift: 0,
        //       ),
        //       size: Size(200, 100),
        //     ),
        //   ],
        // );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final Color color1;
  final Color color2;
  final double shift;
  final double fillFraction;

  WavePainter({
    required this.animationValue,
    required this.color1,
    required this.color2,
    required this.shift,
    this.fillFraction = 0.3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        stops: [fillFraction < 1 ? 1 - fillFraction : 0.7, 1],
        // stops: [0.7, 0.9],
        // colors: [Colors.lightBlueAccent, Colors.blue],
        colors: [color1, color2],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();

    double waveHeight = 12;
    double waveLength = size.width * 2.05;

    path.moveTo(0, size.height * 0.7);

    for (double x = 0; x <= size.width; x++) {
      double y =
          sin(((x / waveLength * 2 * pi) + (animationValue * 2 * pi)) + shift) *
              waveHeight +
              size.height * (fillFraction < 1 ? 1 - fillFraction : 0.7);

      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
