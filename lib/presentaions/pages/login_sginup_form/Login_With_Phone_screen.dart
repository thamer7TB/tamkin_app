import 'package:flutter/material.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/resorces/Colors_Manager.dart';
import '../../../core/resorces/Size_Value_Manager.dart';
import '../../../core/resorces/Strings_Value_Manager.dart';
import '../../widgets/Custom_Button.dart';
import '../../widgets/Custom_TextField.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'Login_With_Email_screen.dart';
class LoginWithPhoneScreen extends StatelessWidget {
  LoginWithPhoneScreen({super.key});

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(height: screenHeight * 0.001),
                Align (
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(ColorsManager.transparent),
                    ),
                    onPressed: () {
                      Navigator.pop(context);// الانتقال للصفحة التالية
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: ColorsManager.primaryColor ,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ),
                Spacer(flex: FlexValueManager.flexValue1,),
                Text(
                  StringsManager.loginTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.09,
                    color: ColorsManager.primaryColor,
                    fontWeight: FontWeight.w900,
                    fontFamily: FontsManager.GEDinkum,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  StringsManager.loginDec,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: ColorsManager.gray,
                    fontWeight: FontWeight.w700,
                    fontFamily: FontsManager.Cairo,
                  ),),
                SizedBox(height: screenHeight * 0.04),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>  LoginWithEmailScreenScreen(),
                              transitionDuration: Duration.zero, // بدون أنيميشن
                              reverseTransitionDuration: Duration.zero, // بدون أنيميشن عند الرجوع أيضًا
                            ),
                          );
                        },
                        child: Text(
                          "By Email",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: ColorsManager.grayLow,
                              fontWeight: FontWeight.w400),),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Text(
                        "By Phone number",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: ColorsManager.primaryColor,),),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.016),
                IntlPhoneField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                      color: ColorsManager.black.withOpacity(0.7),
                      fontFamily: FontsManager.Cairo,
                      fontSize: screenWidth * 0.038,
                    ),
                    isDense: true, // يقلل المساحة الداخلية تلقائيًا
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(RadiusManager.rounded30),
                      borderSide: const BorderSide(
                        color: ColorsManager.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(RadiusManager.rounded30),
                      borderSide: const BorderSide(
                        color: ColorsManager.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(RadiusManager.rounded30),
                      borderSide: const BorderSide(
                        color: ColorsManager.primaryColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: ColorsManager.fourthColor,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.016,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontFamily: "Arial",
                    color: Colors.black87,
                  ),
                  dropdownIconPosition: IconPosition.trailing,
                  flagsButtonPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                  initialCountryCode: 'DZ',
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                ),
                SizedBox(height: screenHeight * 0.008),
                SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    child:  CustomTextField(controller: passwordController ,textInputAction: TextInputAction.done,
                      label: "Password", hintText: "Enter your Password",keyboardType: TextInputType.text , obscureText: true ,isPassword: true,
                    )),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      StringsManager.loginForgetPassword,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: ColorsManager.primaryColor,
                          fontSize: screenWidth * 0.04),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomButton(buttonText: "Login",onPressed: () {},),
                SizedBox(height: screenHeight * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an Account?",
                      textAlign: TextAlign.center ,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04 ,
                        color: ColorsManager.gray , ),

                    ),
                    TextButton(
                      onPressed: () {

                      },
                      child: Text(
                        "Sgin up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: ColorsManager.primaryColor,
                            fontWeight: FontWeight.w400),),
                    ),

                  ],
                ),
                SizedBox(height: screenHeight * 0.04),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                        color: ColorsManager.grayLow,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03),
                      child: Text(
                        "or continue with",
                        style: TextStyle(color: ColorsManager.gray , fontFamily: FontsManager.GEDinkum ,fontSize: screenWidth*0.045 , fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                        color: ColorsManager.grayLow,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Wrap(
                  spacing: screenWidth * 0.04,
                  runSpacing: screenHeight * 0.015,
                  alignment: WrapAlignment.center,
                  children: [
                    IconButton (onPressed: () {
                      // TODO: Add Google Sign-in logic here
                    },
                        icon :   SvgPicture.asset("assets/images/icons/google_icon_loginsvg.svg")),
                    IconButton(onPressed: () {
                      // TODO: Add linkedin Sign-in logic here
                    },
                        icon :   SvgPicture.asset("assets/images/icons/linkedin_icon_login.svg")),
                    IconButton(onPressed: () {
                      // TODO: Add facebook Sign-in logic here
                    },
                        icon :   SvgPicture.asset("assets/images/icons/facebook_icon_login.svg")),

                  ],
                ),
                Spacer(flex: FlexValueManager.flexValue1,),

              ],
            ),
          )),
    );
  }
}