
import 'package:flutter/material.dart';
import 'package:tamkin/core/resorces/Colors_Manager.dart';

import '../../../../../../core/resorces/Fonts_Manager.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.primaryColor,
        centerTitle: true,
        title: const Text('Privacy & Policy' , style: TextStyle( color: Colors.white, fontWeight: FontWeight.w500,),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back , color: ColorsManager.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(screenWidth*0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align (
              alignment: Alignment.center,
              child: Text(
                'Privacy Policy – Temkin App',
                style: TextStyle(
                  fontSize: screenWidth*0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.03),
            Text(
              'By creating an account on Temkin, you agree to our privacy policy :',
              style: TextStyle(fontSize: screenWidth*0.043),
            ),
            SizedBox(height: screenHeight*0.03),
            _buildSectionTitle(context ,'Information Collection'),
            SizedBox(height: screenHeight*0.015),
            Text(
              'We collect only the necessary personal information such as name, email, phone number, location, education level, and interests to provide you with better training and internship opportunities.',
              style: TextStyle(fontSize: screenWidth*0.043),
            ),
            SizedBox(height: screenHeight*0.03),
            _buildSectionTitle(context ,'Use of Information'),
            SizedBox(height: screenHeight*0.015),
            Text(
              'Your data is used strictly to match you with relevant opportunities and improve your user experience.',
              style: TextStyle(fontSize: screenWidth*0.043),
            ),
            SizedBox(height: screenHeight*0.03),
            _buildSectionTitle(context ,'Data Sharing'),
            SizedBox(height: screenHeight*0.015),
            Text(
              'We do not share your personal data with third parties without your consent, except in cases where it\'s necessary to connect you with an opportunity provider (training center or company).',
              style: TextStyle(fontSize: screenWidth*0.043),
            ),
            SizedBox(height: screenHeight*0.03),
            _buildSectionTitle(context ,'Data Security'),
            SizedBox(height: screenHeight*0.015),
            Text(
              'We apply appropriate security measures to protect your data.',
              style: TextStyle(fontSize: screenWidth*0.043),
            ),
            SizedBox(height: screenHeight*0.03),
            _buildSectionTitle(context , 'Your Rights'),
            SizedBox(height: screenHeight*0.015),
            Text(
              'You can access, update, or delete your account and data at any time.',
              style: TextStyle(fontSize: screenWidth*0.043),
            ),
            SizedBox(height: screenHeight*0.03),
            Text(
              'For more details, please visit our full Privacy Policy page.',
              style: TextStyle(fontSize: screenWidth*0.043),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context , String title) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Text(
      title,
      style:  TextStyle(
        fontSize: screenWidth*0.05,
        fontWeight: FontWeight.bold,
        color: ColorsManager.primaryColor, // You can change this to your primary color
      ),
    );
  }
}