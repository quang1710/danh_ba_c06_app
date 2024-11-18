import 'package:danh_ba_c06_app/core/util/constants/constant_color.dart';
import 'package:flutter/material.dart';

// Widget dùng chung cho các nút nhấn
class ColorContainer extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final VoidCallback onPressed;
  final double borderRadius;
  final bool active;
  final Color activeBackgroundColor;
  final Color deactiveBackgroundColor;
  final Color textColor;
  final double textSize;
  const ColorContainer({
    super.key,
    this.width = 200,
    this.height = 50,
    this.text = "",
    required this.onPressed,
    this.borderRadius = 12,
    this.active = true,
    this.activeBackgroundColor = appGMBred,
    this.deactiveBackgroundColor = appLightGrey,
    this.textColor = Colors.white,
    this.textSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: active ?
          activeBackgroundColor :
          deactiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextButton(
        onPressed: active ?
          onPressed :
          (){},
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
          ),
        )
      ),
    );
  }
}