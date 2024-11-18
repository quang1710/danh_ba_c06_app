import 'package:danh_ba_c06_app/core/util/constants/constant_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Widget dùng chung cho các text field
class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final double height;
  final double width;
  final double borderRadius;
  final String hintText;
  final Color backgroundColor;
  final Color hintTextColor;
  final bool inputNumber;
  const CustomTextfield({
    super.key,
    required this.controller,
    this.height = 50.0,
    this.width = 200.0,
    this.borderRadius = 5,
    this.hintText = "",
    this.backgroundColor = appLightGrey,
    this.hintTextColor = appHintTextColor,
    this.inputNumber = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius)
      ),
      child: TextField(
        // Thay đổi màu của con trỏ
        cursorColor: Colors.black,
        // Để cho phép TextField chỉ hiển thị tối đa 1 lines
        maxLines: 1,
        // Để người dùng có thể xem nội dung còn lại bằng cách lướt xuống
        scrollPadding: const EdgeInsets.all(20),
        // Controller kiểm soát nội dung nhập vào
        controller: controller,
        // Thiết lập loại bàn phím (hỗn hợp hoặc số)
        keyboardType: inputNumber ?
          TextInputType.number :
          TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: hintTextColor,
          ),
          // Đặt màu nền của TextField thành màu tùy chọn
          filled: true,
          fillColor: backgroundColor,
          // Đặt padding của văn bản bên trong thành 10
          contentPadding: const EdgeInsets.all(10),
          // Điều chỉnh border cho textfield
          enabledBorder: OutlineInputBorder(
            borderRadius:
                const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
                color: backgroundColor) // Border màu xám khi không focus
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(
                color: backgroundColor,), // Border màu xám khi focus
          ),
        ),
        // Giới hạn số ký tự nhập vào textfield
        inputFormatters: [
          LengthLimitingTextInputFormatter(30),
        ],
      ),
    );
  }
}