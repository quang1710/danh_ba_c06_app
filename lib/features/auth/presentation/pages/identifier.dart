import 'package:danh_ba_c06_app/features/auth/presentation/widgets/color_container.dart';
import 'package:danh_ba_c06_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class Identifier extends StatefulWidget {
  const Identifier({super.key});

  @override
  State<Identifier> createState() => _IdentifierState();
}

class _IdentifierState extends State<Identifier> {
  final TextEditingController controller = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    // Lấy chiều ngang của màn hình
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 10,),
            Image.asset(
              "assets/images/danh_ba.jpeg",
              height: 200,
            ),
            const Text (
              "Nhập số điện thoại",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
            ),
            const Spacer(flex: 1,),
            CustomTextfield(
              controller: controller,
              width: screenWidth * 0.9,
              height: 60,
              inputNumber: true,
            ),
            const Spacer(flex: 1,),
            ColorContainer(
              height: 50,
              width: screenWidth * 0.9,
              text: "Xác nhận",
              textSize: 24,
              onPressed: () {
              }
            ),
            const Spacer(flex: 10,),
          ]
        ),
      ),
    );
  }
}