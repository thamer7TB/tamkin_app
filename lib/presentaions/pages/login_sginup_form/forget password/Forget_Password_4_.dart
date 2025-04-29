
// File: forget_password_screen_4.dart
import 'package:flutter/material.dart';
import 'package:tamkin/core/resorces/Colors_Manager.dart';

import '../../../widgets/Custom_Button.dart';
import '../Login_With_Email_screen.dart';


class ForgetPasswordScreen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(screenWidth*0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded, color: ColorsManager.primaryColor, size: screenWidth*0.4),
              SizedBox(height: screenHeight*0.02),
              Text('Password updated', style: TextStyle(fontSize: screenWidth*0.07, fontWeight: FontWeight.bold)),
              SizedBox(height: screenHeight*0.01),
              Text('Your password has been successfully reset.' , style: TextStyle(fontSize:screenWidth*0.037 ),),
              Text('Please log in with your new password.' , style: TextStyle(fontSize:screenWidth*0.037),),
              SizedBox(height: screenHeight*0.02),
              CustomButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginWithEmailScreenScreen()),
                ),
                buttonText: 'Go back to Login',
              ),
            ],
          ),
        ),
      ),
    );
  }
}