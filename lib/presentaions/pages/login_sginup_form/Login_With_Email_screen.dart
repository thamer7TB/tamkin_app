import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/resorces/Colors_Manager.dart';
import '../../../core/resorces/Size_Value_Manager.dart';
import '../../../core/resorces/Strings_Value_Manager.dart';
import '../../../services/providers/Auth_Provider.dart';
import '../../widgets/Custom_Button.dart';
import '../../widgets/Custom_TextField.dart';
import 'Login_With_Phone_screen.dart';

class LoginWithEmailScreenScreen extends StatelessWidget {
  LoginWithEmailScreenScreen({super.key});

  final TextEditingController emailController = TextEditingController();
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
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(ColorsManager.transparent),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, "LoginSginupOnbording");
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
                StringsManager.loginTitle,
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
                StringsManager.loginDec,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: ColorsManager.gray,
                  fontWeight: FontWeight.w700,
                  fontFamily: FontsManager.Cairo,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      "   By Email",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: ColorsManager.primaryColor,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                LoginWithPhoneScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: Text(
                        "By Phone number",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: ColorsManager.grayLow,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: CustomTextField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    label: "Email",
                    hintText: "Enter your Email",
                    keyboardType: TextInputType.emailAddress),
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, _) => CustomTextField(
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
              ),
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
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) => Column(
                  children: [
                    CustomButton(
                      buttonText: authProvider.isLoading ? "" : "Login",
                      onPressed: authProvider.isLoading
                          ? null
                          : () {
                        authProvider.login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
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
              SizedBox(height: screenHeight * 0.06),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an Account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: ColorsManager.gray,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Sgin up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: ColorsManager.primaryColor,
                          fontWeight: FontWeight.w400),
                    ),
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
                    padding:
                    EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                    child: Text(
                      "or continue with",
                      style: TextStyle(
                          color: ColorsManager.gray,
                          fontFamily: FontsManager.GEDinkum,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold),
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
                      icon: SvgPicture.asset(
                          "assets/images/icons/google_icon_loginsvg.svg")),
                  IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                          "assets/images/icons/linkedin_icon_login.svg")),
                  IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                          "assets/images/icons/facebook_icon_login.svg")),
                ],
              ),
              Spacer(flex: FlexValueManager.flexValue1),
            ],
          ),
        ),
      ),
    );
  }
}
