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
      backgroundColor: ColorsManager.UserGrayScaffold,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Center Profile Card
            _buildCenterProfileCard(context),

            // 2. Course Details Section
            _buildSection(
              context: context,
              title: 'Course Details',
              icon: Icons.info_outline,
              items: [
                _buildDetailItem(
                  context: context,
                  icon: Icons.location_on,
                  title: 'Location',
                  value: course.wilaya,
                ),
                _buildDetailItem(
                  context: context,
                  icon: Icons.calendar_today_rounded,
                  title: 'Start Date',
                  value: course.startDate,
                ),
                _buildDetailItem(
                  context: context,
                  icon: Icons.category,
                  title: 'Domain',
                  value: course.domain,
                ),
              ],
            ),

            // 3. Description Section
            _buildSection(
              context: context,
              title: 'Description',
              icon: Icons.description_outlined,
              items: [
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Text(
                    course.description ?? 'No description provided.',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      height: 1.5,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // 4. Apply Button
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: CustomButton(
                buttonText: 'Apply Now',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Application feature coming soon')),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(10),
          left: Radius.circular(10),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: ColorsManager.primaryColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Course Details',
        style: TextStyle(
          color: ColorsManager.primaryColor,
          fontWeight: FontWeight.bold,
          fontFamily: FontsManager.GEDinkum,
          fontSize: MediaQuery.of(context).size.width * 0.05,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: ColorsManager.primaryColor),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share feature coming soon')),
            );
          },
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildCenterProfileCard(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CenterProfileScreen(centerId: course.centerId),
          ),
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Navigating to ${course.centerName} profile')),
        // );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.013,
        ),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: screenWidth * 0.01,
              offset: Offset(0, screenHeight * 0.005),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorsManager.primaryColor,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: screenWidth * 0.06,
                backgroundColor: Colors.grey[200],
                child: course.logoUrl != null && course.logoUrl!.isNotEmpty
                    ? ClipOval(
                  child: Image.network(
                    course.logoUrl!,
                    fit: BoxFit.cover,
                    width: screenWidth * 0.12,
                    height: screenWidth * 0.12,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Failed to load image: ${course.logoUrl}, error: $error');
                      return Image.asset(
                        'assets/images/center_placeholder.png',
                        fit: BoxFit.cover,
                        width: screenWidth * 0.12,
                        height: screenWidth * 0.12,
                      );
                    },
                  ),
                )
                    : Image.asset(
                  'assets/images/center_placeholder.png',
                  fit: BoxFit.cover,
                  width: screenWidth * 0.12,
                  height: screenWidth * 0.12,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.centerName,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsManager.GEDinkum,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    course.wilaya,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: ColorsManager.primaryColor,
              size: screenWidth * 0.06,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.013,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: screenWidth * 0.01,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: screenWidth * 0.065,
                  color: ColorsManager.gray,
                ),
                SizedBox(width: screenWidth * 0.04),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsManager.GEDinkum,
                  ),
                ),
              ],
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.03,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: screenWidth * 0.055,
            color: ColorsManager.primaryColor,
          ),
          SizedBox(width: screenWidth * 0.04),
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.038,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}