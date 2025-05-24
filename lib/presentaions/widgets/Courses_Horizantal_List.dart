
import 'package:flutter/material.dart';
import '../../../../../models/User_1/course_opportunity_model.dart';
import '../../../../../services/User_1/course_opportunity_service.dart';
import 'course_opportunity_card.dart';

class CoursesHorizontalList extends StatelessWidget {
  CoursesHorizontalList({super.key});

  final CourseOpportunityService _service = CourseOpportunityService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenWidth * 0.75,
      child: FutureBuilder<List<CourseOpportunityModel>>(
        future: _service.fetchCourseOpportunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load courses."));
          }

          final courses = snapshot.data ?? [];

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.01),
                child: SizedBox(
                  width: screenWidth * 0.65, // إضافة العرض الثابت هنا
                  child: CourseOpportunityCard(course: course),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
