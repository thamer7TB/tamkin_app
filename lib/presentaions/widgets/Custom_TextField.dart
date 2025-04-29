import 'package:flutter/material.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';

import '../../core/resorces/Colors_Manager.dart';
import '../../core/resorces/Size_Value_Manager.dart';

class CustomTextField extends StatelessWidget {
  final TextInputAction textInputAction ;
  final TextEditingController controller;
  final String label ;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onToggleVisibility, required this.label, required this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return TextField(
      textInputAction: textInputAction,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle( color: ColorsManager.black.withOpacity(0.7), fontFamily: FontsManager.Cairo) ,
        hintText: hintText,
        hintStyle: TextStyle( color: ColorsManager.gray , fontWeight: FontWeight.w300 ) ,
        filled: true,
        fillColor: ColorsManager.fourthColor ,
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: onToggleVisibility,
        )
            : null,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorsManager.primaryColor , width: 2),
          borderRadius: BorderRadius.circular(RadiusManager.rounded30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide( color: ColorsManager.transparent ),
          borderRadius: BorderRadius.circular(RadiusManager.rounded30),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RadiusManager.rounded30),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.016,
        ),

      ),
    );
  }
}
