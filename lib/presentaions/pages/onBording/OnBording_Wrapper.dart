
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tamkin/presentaions/pages/onBording/OnBording_Company.dart';
import '../../../core/resorces/Colors_Manager.dart';
import 'OnBording_Training_Center.dart';
import 'OnBording_User.dart';

class OnBoardingWrapper extends StatefulWidget {
  const OnBoardingWrapper({super.key});

  @override
  State<OnBoardingWrapper> createState() => _OnBoardingWrapperState();
}

class _OnBoardingWrapperState extends State<OnBoardingWrapper> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                OnBordingUser(controller: _pageController ,),        // صفحتك الأولى
                OnBordingCompany(controller: _pageController,),     // صفحتك الثانية
                OnBordingCenter(controller: _pageController,),      // صفحتك الثالثة
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),  // استخدام screenHeight لجعل المسافة متجاوبة
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: WormEffect(
              dotHeight: screenHeight * 0.01,  // استخدام screenHeight لجعل حجم النقاط متجاوب
              dotWidth: screenWidth * 0.02,    // استخدام screenWidth لتحديد عرض النقاط
              spacing: screenWidth * 0.02,      // ضبط المسافة بين النقاط بناءً على الشاشة
              activeDotColor: ColorsManager.primaryColor,
              dotColor: ColorsManager.thirdColor,
            ),
          ),
          SizedBox(height: screenHeight * 0.06),  // استخدام screenHeight لتحديد المسافة بين المؤشر وبقية العناصر
        ],
      ),
    );
  }
}

