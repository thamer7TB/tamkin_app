
// File: forget_password_screen_2.dart
import 'package:flutter/material.dart';
import '../../../../core/resorces/Colors_Manager.dart';
import '../../../../core/resorces/Fonts_Manager.dart';
import '../../../../services/forgot_password_service.dart';
import '../../../widgets/Custom_Button.dart';
import 'Forget_Password_3_.dart';


class ForgetPasswordScreen2 extends StatefulWidget {
  final String email;
  ForgetPasswordScreen2({required this.email});

  @override
  _ForgetPasswordScreen2State createState() => _ForgetPasswordScreen2State();
}

class _ForgetPasswordScreen2State extends State<ForgetPasswordScreen2> {
  List<TextEditingController> _otpControllers =
  List.generate(4, (_) => TextEditingController());
  String? _error;
  int _timer = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (_timer > 0) {
        setState(() => _timer--);
        return true;
      }
      return false;
    });
  }

  void _submit() async {
    final otp = _otpControllers.map((e) => e.text).join();
    final isValid = await ForgetPasswordService.verifyOtp(otp);
    if (isValid) {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => ForgetPasswordScreen3(),
      ));
    } else {
      setState(() => _error = 'Invalid OTP');
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('We sent the OTP code via email to \n ${widget.email}'
                 ,textAlign: TextAlign.center,
                 style:TextStyle(fontSize: screenWidth*0.04 , color: ColorsManager.gray) ,),

            SizedBox(height: screenHeight*0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) => _buildOtpField(i)),
            ),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red)),
            SizedBox(height: screenHeight*0.04),
            Text('Wait for $_timer' , style: TextStyle(fontSize: screenWidth*0.04),),
            if (_timer == 0)
              TextButton(
                onPressed: () {
                  setState(() => _timer = 60);
                  _startTimer();
                },
                child: Text('Send Again' , style: TextStyle(color: ColorsManager.primaryColor , fontSize: screenWidth*0.04),)
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

  Widget _buildOtpField(int i) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth*0.17,
      margin: EdgeInsets.symmetric(horizontal: screenHeight*0.013),

      child: TextField(
        textInputAction: TextInputAction.next,
        controller: _otpControllers[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15)
          ),
        ),
      ),
    );
  }
}