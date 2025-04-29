// File: forget_password_screen_1.dart
import 'package:flutter/material.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';
import '../../../../core/resorces/Colors_Manager.dart';
import '../../../../core/resorces/Size_Value_Manager.dart';
import '../../../../services/forgot_password_service.dart';
import '../../../widgets/Custom_Button.dart';
import 'Forget_Password_2_.dart';


class ForgetPasswordScreen1 extends StatefulWidget {
  @override
  _ForgetPasswordScreen1State createState() => _ForgetPasswordScreen1State();
}

class _ForgetPasswordScreen1State extends State<ForgetPasswordScreen1> {
  final _emailController = TextEditingController();
  String? _error;

  void _submit() async {
    final email = _emailController.text.trim();
    final exists = await ForgetPasswordService.verifyEmailExists(email);
    if (exists) {
      await ForgetPasswordService.sendOtp(email);
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => ForgetPasswordScreen2(email: email),
      ));
    } else {
      setState(() => _error = 'Email not registered');
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
            Text('Reset your account password and access \n to your account again'
            ,textAlign: TextAlign.center,
            style:TextStyle(fontSize: screenWidth*0.04 , color: ColorsManager.gray) ,),
            SizedBox(height: screenHeight*0.04),
            SizedBox(
              width: double.infinity,
              child: TextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorsManager.grayLow2,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.016,
                  ),
                  hintText: 'Email',
                  errorText: _error,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: ColorsManager.transparent , width: 2),
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

