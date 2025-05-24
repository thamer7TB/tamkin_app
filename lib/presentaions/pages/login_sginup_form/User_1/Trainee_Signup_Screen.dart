import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tamkin/core/resorces/Colors_Manager.dart';
import 'package:tamkin/core/resorces/Size_Value_Manager.dart';
import 'package:tamkin/core/resorces/Strings_Value_Manager.dart';
import 'package:tamkin/presentaions/pages/login_sginup_form/User_1/Profile_Start_Form_Screen.dart';
import 'package:tamkin/services/providers/Auth_Provider.dart';
import '../../../widgets/Custom_Button.dart';
import '../../../widgets/Custom_TextField.dart';
import '../Login_With_Email_screen.dart';

class TraineeSignupScreen extends StatelessWidget {
  TraineeSignupScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset("assets/images/onbording/main_top_rghit.png", scale: 0.95),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset("assets/images/onbording/main_bottom_left.png", scale: 1.3),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(ColorsManager.transparent),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: ColorsManager.primaryColor,
                        size: screenWidth * 0.06,
                      ),
                    ),
                  ),
                  Spacer(flex: FlexValueManager.flexValue1),
                  Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.09,
                      color: ColorsManager.primaryColor,
                      fontWeight: FontWeight.w900,
                      fontFamily: FontsManager.GEDinkum,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "Join us now",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: ColorsManager.gray,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontsManager.Cairo,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    child: CustomTextField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      label: "Email",
                      hintText: "Enter your Email",
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  IntlPhoneField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(
                        color: ColorsManager.black.withOpacity(0.7),
                        fontFamily: FontsManager.Cairo,
                        fontSize: screenWidth * 0.038,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(RadiusManager.rounded30),
                        borderSide: const BorderSide(color: ColorsManager.primaryColor, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(RadiusManager.rounded30),
                        borderSide: const BorderSide(color: ColorsManager.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(RadiusManager.rounded30),
                        borderSide: const BorderSide(color: ColorsManager.primaryColor, width: 2),
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
                      print('📞 Phone number entered: ${phone.completeNumber}');
                    },
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    child: CustomTextField(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      label: "Password",
                      hintText: "Enter your Password",
                      keyboardType: TextInputType.text,
                      obscureText: authProvider.obscurePassword,
                      isPassword: true,
                      onToggleVisibility: authProvider.togglePasswordVisibility,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    child: CustomTextField(
                      controller: confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      label: "Confirm Password",
                      hintText: "Confirm your Password",
                      keyboardType: TextInputType.text,
                      obscureText: authProvider.obscurePassword,
                      isPassword: true,
                      onToggleVisibility: authProvider.togglePasswordVisibility,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) => Column(
                      children: [
                        CustomButton(
                          buttonText: authProvider.isLoading ? "" : "Sign Up",
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                            print('🔍 Starting signup process');
                            // استدعاء signupTrainee للتحقق من البيانات
                            await authProvider.signupTrainee(
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              password: passwordController.text.trim(),
                              confirmPassword: confirmPasswordController.text.trim(),
                            );

                            // التحقق من وجود أخطاء بعد التحقق
                            if (authProvider.errorMessage == null) {
                              print('✅ Validation successful, navigating to ProfileScreen');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProfileScreen(
                                    signupData: {
                                      'email': emailController.text.trim(),
                                      'phone': phoneController.text.trim(),
                                      'password': passwordController.text.trim(),
                                    },
                                  ),
                                ),
                              );
                            } else {
                              print('❌ Validation failed: ${authProvider.errorMessage}');
                            }
                          },
                          child: authProvider.isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                              : null,
                        ),
                        if (authProvider.errorMessage != null)
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.015),
                            child: Text(
                              authProvider.errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: screenWidth * 0.038,
                                fontFamily: FontsManager.Cairo,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an Account?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: ColorsManager.gray,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => LoginWithEmailScreenScreen()));
                        },
                        child: Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: ColorsManager.primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: ColorsManager.grayLow,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                        child: Text(
                          "or continue with",
                          style: TextStyle(
                            color: ColorsManager.gray,
                            fontFamily: FontsManager.GEDinkum,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
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
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/images/icons/google_icon_loginsvg.svg"),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/images/icons/linkedin_icon_login.svg"),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/images/icons/facebook_icon_login.svg"),
                      ),
                    ],
                  ),
                  Spacer(flex: FlexValueManager.flexValue6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
