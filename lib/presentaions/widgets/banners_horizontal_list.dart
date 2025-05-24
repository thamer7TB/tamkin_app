import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/resorces/Colors_Manager.dart';
import '../pages/Placeholder.dart';

class BannersHorizontalList extends StatefulWidget {
  const BannersHorizontalList({super.key});

  @override
  State<BannersHorizontalList> createState() => _BannersHorizontalListState();
}

class _BannersHorizontalListState extends State<BannersHorizontalList> {
  final PageController _pageController = PageController(
    viewportFraction: 0.85, // تقليل المساحة لإظهار الصور الجانبية بشكل أوضح
  );
  late Timer _timer;
  int _currentPage = 0;

  // قائمة الصور
  static const List<String> bannerImages = [
    'assets/images/banner1.png',
    'assets/images/tesst.png',
    'assets/images/banner3.png',
  ];

  @override
  void initState() {
    super.initState();
    // إعداد المؤقت للتمرير التلقائي كل ثانيتين
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentPage < bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });

    // تحديث الصفحة الحالية أثناء التمرير
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.25 + 20, // زيادة الارتفاع لاستيعاب النقاط
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              clipBehavior: Clip.none, // السماح بظهور الصور الجانبية
              itemCount: bannerImages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                // حساب نسبة التحجيم بناءً على المسافة من الصفحة النشطة
                double scale = 1.0;
                if (_pageController.position.haveDimensions) {
                  scale = 1 - ((_currentPage - index).abs() * 0.1); // تصغير طفيف
                  scale = scale.clamp(0.9, 1.0); // الحد الأدنى 0.9 والأقصى 1.0
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FeatureUnavailableScreen(
                          title: 'Banner ${index + 1}',
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.005), // المسافة صغيرة جدًا
                    child: Transform.scale(
                      scale: scale, // تطبيق تأثير Zoom In/Zoom Out
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage(bannerImages[index]),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Dot Indicators أسفل الصور مباشرة
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.01),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: bannerImages.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: ColorsManager.primaryColor,
                dotColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}