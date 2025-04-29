

import 'package:flutter/material.dart';

import '../../core/resorces/Colors_Manager.dart';
import 'Custom_Button.dart';

class CourseDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> courseData;

  const CourseDetailsScreen({super.key, required this.courseData});

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
            // صورة الشعار
            Center(
              child: CircleAvatar(
                radius: screenWidth * 0.18,
                backgroundImage: NetworkImage(courseData['logoUrl']),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // عنوان الدورة
            Text(
              courseData['courseTitle'] ?? '',
              style: TextStyle(fontSize: screenWidth * 0.065, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.01),

            // اسم المركز
            Text(
              courseData['centerName'] ?? '',
              style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.grey[600]),
            ),
            Divider(height: screenHeight * 0.04 , color:  Colors.grey[400],),

            // تفاصيل أخرى
            _buildDetailRow(context, Icons.location_on, ' Location', courseData['wilaya']),
            SizedBox(height: screenHeight * 0.01),
            _buildDetailRow(context, Icons.calendar_today_rounded, ' Start Date', courseData['startDate']),
            SizedBox(height: screenHeight * 0.01),
            _buildDetailRow(context, Icons.category, ' Domain', courseData['domain']),
            SizedBox(height: screenHeight * 0.01),
            Divider(height: screenHeight * 0.04),

            // وصف الدورة
            Text(
              'Description',
              style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              courseData['description'] ?? '',
              style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey[700]),
            ),
            SizedBox(height: screenHeight * 0.1),
            // زر التقديم
            CustomButton(buttonText: 'Apply Now' , onPressed: () {

            },),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context ,IconData icon ,  String title, String? value) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
      child: Row(
        children: [
          Icon(icon , size: screenWidth * 0.06, color: ColorsManager.primaryColor ),
          SizedBox(width: screenWidth*0.02),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.042),
          ),
          SizedBox(width: screenWidth*0.04),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

