
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/resorces/Colors_Manager.dart';
import '../../core/resorces/Fonts_Manager.dart';
import '../../models/User_1/course_opportunity_model.dart';
import '../pages/home/User_1/screens/Home_tab/Center_Profile_Screen.dart';
import 'Custom_Button.dart';

class CourseDetailsScreen extends StatelessWidget {
  final CourseOpportunityModel course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Course Details', style: TextStyle(fontSize: screenWidth * 0.05)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات المركز + التنقل للبروفايل
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CenterProfileScreen(centerId: course.centerId),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(course.logoUrl ?? 'https://via.placeholder.com/150'),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    course.centerName,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsManager.GEDinkum,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Text(
              course.centerName,
              style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.grey[600]),
            ),
            Divider(height: screenHeight * 0.04, color: Colors.grey[400]),

            _buildDetailRow(context, Icons.location_on, ' Location', course.wilaya),
            const SizedBox(height: 8),
            _buildDetailRow(context, Icons.calendar_today_rounded, ' Start Date', course.startDate),
            const SizedBox(height: 8),
            _buildDetailRow(context, Icons.category, ' Domain', course.domain),
            const SizedBox(height: 8),
            Divider(height: screenHeight * 0.04),

            // وصف التكوين
            Text(
              'Description',
              style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              course.description ?? "No description provided.",
              style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey[700]),
            ),
            const SizedBox(height: 32),

            // زر التقديم
            CustomButton(
              buttonText: 'Apply Now',
              onPressed: () {
                // TODO: تنفيذ التقديم
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String title, String value) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
      child: Row(
        children: [
          Icon(icon, size: screenWidth * 0.06, color: ColorsManager.primaryColor),
          SizedBox(width: screenWidth * 0.02),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.042),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}


