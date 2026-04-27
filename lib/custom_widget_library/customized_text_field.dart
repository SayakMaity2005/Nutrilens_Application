import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';

class CustomizedTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final FocusNode? prevNode;
  final int maxLength;
  final int maxVal;
  final int minVal;
  final String? hintText;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? disabledBorder;
  final InputBorder? errorBorder;

  const CustomizedTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.nextNode,
    this.prevNode,
    this.maxLength=10,
    this.maxVal=9999999999,
    this.minVal=0,
    this.hintText,
    this.textAlign,
    this.contentPadding,
    this.border,
    this.disabledBorder,
    this.errorBorder,
  });

  @override
  State<CustomizedTextField> createState() => _CustomizedTextFieldState();
}

class _CustomizedTextFieldState extends State<CustomizedTextField> {
  late String? _errorMsg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _errorMsg = null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final palette = Theme.of(context).extension<AppPalette>()!;

    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      onChanged: (value) {
        if (value.isEmpty) {
          FocusScope.of(context).requestFocus(widget.prevNode);
        }
        if (double.parse(value) > widget.maxVal) {
          setState(() {
            _errorMsg = '<=${widget.maxVal}';
          });
        } else if (double.parse(value) < widget.minVal) {
          setState(() {
            _errorMsg = '>=${widget.minVal}';
          });
        } else {
          setState(() {
            _errorMsg = null;
          });
          if (value.length == widget.maxLength) {
            FocusScope.of(context).requestFocus(widget.nextNode);
          }
        }
      },
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      cursorColor: palette.selectColor3,

      decoration: InputDecoration(
        hintText: widget.hintText,
        counterText: '',
        filled: true,
        fillColor: palette.unselectColor1,
        isDense: false,
        contentPadding: EdgeInsetsGeometry.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        errorText: _errorMsg,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 2, color: palette.errorColor),
        ),
      ),
    );
  }
}
