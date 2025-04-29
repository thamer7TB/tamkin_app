
// File: forget_password_screen_3.dart
import 'package:flutter/material.dart';
import '../../../../core/resorces/Colors_Manager.dart';
import '../../../../core/resorces/Fonts_Manager.dart';
import '../../../../core/resorces/Size_Value_Manager.dart';
import '../../../../services/forgot_password_service.dart';
import '../../../widgets/Custom_Button.dart';
import 'Forget_Password_4_.dart';

class ForgetPasswordScreen3 extends StatefulWidget {
  @override
  _ForgetPasswordScreen3State createState() => _ForgetPasswordScreen3State();
}

class _ForgetPasswordScreen3State extends State<ForgetPasswordScreen3> {
  final _pass1 = TextEditingController();
  final _pass2 = TextEditingController();
  String? _error;

  void _submit() async {
    final valid = await ForgetPasswordService.resetPassword(_pass1.text, _pass2.text);
    if (valid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ForgetPasswordScreen4()),
      );
    } else {
      setState(() => _error = 'Password and confirm password do not match');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back , color:  ColorsManager.primaryColor),
            onPressed: () {
              Navigator.pop(context); // يرجع للخلف
            },
          ),
          centerTitle:true ,
          title: Text('Forget  Password' , style: TextStyle(fontFamily: FontsManager.GEDinkum , fontWeight: FontWeight.w600),)
      ),
      body: Padding(
        padding:  EdgeInsets.all(screenWidth*0.06),
        child: Column(
          children: [
            Text('Reset your password and access\n your account again'
            ,textAlign: TextAlign.center,
             style:TextStyle(fontSize: screenWidth*0.04 , color: ColorsManager.gray)),
            SizedBox(height: screenHeight*0.04),
            SizedBox(
              width: double.infinity,
              child: TextField(
                obscureText: true,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                controller: _pass1,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorsManager.grayLow2,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.016,
                  ),
                  hintText: 'New password',
                  errorText: _error,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ColorsManager.transparent),
                    borderRadius: BorderRadius.circular(RadiusManager.rounded30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide( color: ColorsManager.transparent ),
                    borderRadius: BorderRadius.circular(RadiusManager.rounded30),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.02),
            SizedBox(
              width: double.infinity,
              child: TextField(
                obscureText: true,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                controller: _pass2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorsManager.grayLow2,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.016,
                  ),
                  hintText: 'Confirm your password',
                  errorText: _error,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ColorsManager.transparent),
                    borderRadius: BorderRadius.circular(RadiusManager.rounded30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide( color: ColorsManager.transparent ),
                    borderRadius: BorderRadius.circular(RadiusManager.rounded30),
                  ),
                ),
              ),
            ),
            Spacer(),
            CustomButton(
              onPressed: _submit,
              buttonText: "Submit",
            ),
            //ElevatedButton(onPressed: _submit, child: Text('Submit')),
            SizedBox(height: screenHeight*0.03),
          ],
        ),
      ),
    );
  }
}
