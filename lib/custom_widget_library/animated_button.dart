import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final double height;
  final double width;
  final Duration? duration;
  final Curve? curve;
  final BoxDecoration? decoration;
  final void Function()? onTap;
  final double onTapScaleFactor;
  final Widget? child;
  const AnimatedButton({
    super.key,
    this.height = 60,
    this.width = 60,
    this.duration,
    this.curve,
    this.decoration,
    this.onTap,
    this.onTapScaleFactor = 0.92,
    this.child,
  });

  @override
  State<StatefulWidget> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  late double _scale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scale = 1;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          _scale = widget.onTapScaleFactor;
        });
      },
      onTapCancel: () {
        setState(() {
          _scale = 1;
        });
      },
      onTapUp: (_) {
        setState(() {
          _scale = 1;
        });
      },
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Center(
          child: AnimatedScale(
            scale: _scale,
            duration: widget.duration ?? Duration(milliseconds: 300),
            curve: widget.curve ?? Curves.easeInOutBack,
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration:
                  widget.decoration ??
                  BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(12),
                  ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
