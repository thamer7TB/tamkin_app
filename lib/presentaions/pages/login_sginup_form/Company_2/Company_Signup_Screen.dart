import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resorces/Colors_Manager.dart';
import '../../../../core/resorces/Size_Value_Manager.dart';
import '../../../../core/resorces/Fonts_Manager.dart';
import '../../../../services/providers/Auth_Provider.dart';
import '../../../widgets/Custom_Button.dart';
import '../../../widgets/Custom_TextField.dart';
import '../Login_With_Email_screen.dart';

class CompanySignupScreen extends StatelessWidget {
  CompanySignupScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController registrationNumberController = TextEditingController();

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
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: ColorsManager.primaryColor, size: screenWidth * 0.06),
                    ),
                  ),
                  Spacer(flex: 1),
                  Text(
                    "Create Company Account",
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      color: ColorsManager.primaryColor,
                      fontWeight: FontWeight.w900,
                      fontFamily: FontsManager.GEDinkum,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    "Welcome! Let's get your business online.",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: ColorsManager.gray,
                      fontFamily: FontsManager.Cairo,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Email field
                  SizedBox(
                    height: screenHeight * 0.07,
                    child: CustomTextField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      label: "Email",
                      hintText: "Enter company email",
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Phone field
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
                      print(phone.completeNumber);
                    },
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Commercial Registration Number
                  SizedBox(
                    height: screenHeight * 0.07,
                    child: CustomTextField(
                      controller: registrationNumberController, // يمكنك ربطه لاحقًا بـ model أو logic
                      textInputAction: TextInputAction.next,
                      label: "Commercial Registration No",
                      hintText: "Enter registration number",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Password field
                  SizedBox(
                    height: screenHeight * 0.07,
                    child: CustomTextField(
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      label: "Password",
                      hintText: "Create a password",
                      keyboardType: TextInputType.text,
                      obscureText: authProvider.obscurePassword,
                      isPassword: true,
                      onToggleVisibility: authProvider.togglePasswordVisibility,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Confirm password
                  SizedBox(
                    height: screenHeight * 0.07,
                    child: CustomTextField(
                      controller: confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      label: "Confirm Password",
                      hintText: "Re-enter password",
                      keyboardType: TextInputType.text,
                      obscureText: authProvider.obscurePassword,
                      isPassword: true,
                      onToggleVisibility: authProvider.togglePasswordVisibility,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Sign up button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) => Column(
                      children: [
                        CustomButton(
                          buttonText: authProvider.isLoading ? "" : "Sign Up",
                          onPressed: authProvider.isLoading
                              ? null
                              : () {
                            authProvider.signupCompany(
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              password: passwordController.text.trim(),
                              confirmPassword: confirmPasswordController.text.trim(),
                              registrationNumber: registrationNumberController.text.trim(),
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
                            padding: EdgeInsets.only(top: screenHeight * 0.005),
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

                  SizedBox(height: screenHeight * 0.01),

                  // Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: screenWidth * 0.04, color: ColorsManager.gray),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => LoginWithEmailScreenScreen()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: ColorsManager.primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Social login
                  Row(
                    children: [
                      Expanded(child: Divider(thickness: 1.5, color: ColorsManager.grayLow)),
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
                      Expanded(child: Divider(thickness: 1.5, color: ColorsManager.grayLow)),
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
                  Spacer(flex: FlexValueManager.flexValue9),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
