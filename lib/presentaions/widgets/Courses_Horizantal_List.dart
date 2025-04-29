

import 'package:flutter/material.dart';
import 'course_opportunity_card.dart'; // استدعاء ويدجت البطاقة التي أنشأناها

class CoursesHorizontalList extends StatelessWidget {
  CoursesHorizontalList({super.key});

  // البيانات: قائمة الفرص
  final List<Map<String, dynamic>> courses = [
    {
      'courseTitle': 'Web Development Bootcamp',
      'centerName': 'Algerian Tech Center',
      'wilaya': 'Algiers',
      'domain': 'Technology',
      'startDate': '1 May 2025',
      'description': 'An intensive web dev training program covering HTML, CSS, JS, and frameworks.',
      'logoUrl': 'https://example.com/logo1.png',
    },
    {
      'courseTitle': 'Graphic Design Fundamentals',
      'centerName': 'Design Academy DZ',
      'wilaya': 'Oran',
      'domain': 'Design',
      'startDate': '10 May 2025',
      'description': 'Learn the basics of graphic design including color theory, typography, and layout.',
      'logoUrl': 'https://example.com/logo2.png',
    },
    {
      'courseTitle': 'Mobile App Development',
      'centerName': 'MobilePro Center',
      'wilaya': 'Constantine',
      'domain': 'Mobile Development',
      'startDate': '20 May 2025',
      'description': 'Build Android and iOS apps using Flutter and Firebase.',
      'logoUrl': 'https://example.com/logo3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
     // height: screenWidth * 0.65, // ارتفاع السكشن
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.03),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context , '/courseDetails', arguments: course);
              },
              child: CourseOpportunityCard(
                courseTitle: course['courseTitle'],
                centerName: course['centerName'],
                wilaya: course['wilaya'],
                domain: course['domain'],
                startDate: course['startDate'],
                description: course['description'],
                logoUrl: course['logoUrl'],
              ),
            ),
          );
        },
      ),
    );
  }
}
