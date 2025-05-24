
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as icons;
import '../../../models/User_1/service_model.dart';
import '../../services/User_1/service_card.dart';

class ServicesHorizontalList extends StatelessWidget {
  const ServicesHorizontalList({super.key});

  // قائمة الخدمات مع الأيقونات
  static final List<ServiceModel> services = [
    // حجز دورات تدريبية
    ServiceModel(title: 'Book Training Courses', icon: icons.Icons.book_online),
    // استشارات مهنية
    ServiceModel(title: 'Career Consultations', icon: icons.Icons.support_agent),
    // تقييم المهارات
    ServiceModel(title: 'Skill Assessment', icon: icons.Icons.assessment),
    // مكتبة تعليمية
    ServiceModel(title: 'Educational Library', icon: icons.Icons.library_books),
    // مجتمع المتعلمين
    ServiceModel(title: 'Learners Community', icon: icons.Icons.group),
    // تتبع التقدم
    ServiceModel(title: 'Progress Tracking', icon: icons.Icons.trending_up),
    // إشعارات مخصصة
    ServiceModel(title: 'Custom Notifications', icon: icons.Icons.notifications),
    // البحث عن متدرب
    ServiceModel(title: 'Trainee Search', icon: icons.Icons.person_search),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.18,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.02),
            child: ServiceCard(service: services[index]),
          );
        },
      ),
    );
  }
}