import 'package:flutter/material.dart';
import '../../core/resorces/Colors_Manager.dart';
import '../../core/resorces/Size_Value_Manager.dart';

class CustomButton extends StatelessWidget {
  final String? buttonText;
  final VoidCallback? onPressed;
  final Widget? child;

  const CustomButton({
    super.key,
    this.buttonText,
    this.onPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RadiusManager.rounded30),
          ),
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.013,
          ),
        ),
        onPressed: onPressed,
        child: child ??
            Text(
              buttonText ?? "",
              style: TextStyle(
                color: ColorsManager.white,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }
}
