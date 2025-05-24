import 'package:flutter/material.dart';
import '../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../models/User_1/course_opportunity_model.dart';
import 'Course_Details_Screen.dart';

class CourseOpportunityCard extends StatefulWidget {
  final CourseOpportunityModel course;

  const CourseOpportunityCard({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseOpportunityCard> createState() => _CourseOpportunityCardState();
}

class _CourseOpportunityCardState extends State<CourseOpportunityCard> {
  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() => _isFavorited = !_isFavorited);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final course = widget.course;

    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CourseDetailsScreen(course: course),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.015, // تقليل الهامش الأفقي
              vertical: screenHeight * 0.01,
            ),
            padding: EdgeInsets.all(screenWidth * 0.02), // تقليل الحشوة
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenWidth * 0.035),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.12),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: screenWidth * 0.07,
                    backgroundColor: Colors.grey[200],
                    child: course.logoUrl.isNotEmpty
                        ? ClipOval(
                      child: Image.network(
                        course.logoUrl,
                        fit: BoxFit.cover,
                        width: screenWidth * 0.14,
                        height: screenWidth * 0.14,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('Failed to load image: ${course.logoUrl}, error: $error');
                          return Image.asset(
                            'assets/images/center_placeholder.png',
                            fit: BoxFit.cover,
                            width: screenWidth * 0.14,
                            height: screenWidth * 0.14,
                          );
                        },
                      ),
                    )
                        : Image.asset(
                      'assets/images/center_placeholder.png',
                      fit: BoxFit.cover,
                      width: screenWidth * 0.14,
                      height: screenWidth * 0.14,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    course.centerName,
                    style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: screenHeight * 0.008),
                Text(
                  course.courseTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: screenWidth * 0.041,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: screenWidth * 0.04, color: ColorsManager.primaryColor),
                          SizedBox(width: screenWidth * 0.01),
                          Expanded(
                            child: Text(
                              course.wilaya,
                              style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey[700]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Icon(Icons.category_outlined, size: screenWidth * 0.04, color: ColorsManager.primaryColor),
                          SizedBox(width: screenWidth * 0.01),
                          Expanded(
                            child: Text(
                              course.domain,
                              style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey[700]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: screenWidth * 0.04, color: ColorsManager.primaryColor),
                    SizedBox(width: screenWidth * 0.011),
                    Expanded(
                      child: Text(
                        'Starts on: ${course.startDate}',
                        style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey[700]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailsScreen(course: course),
                            ),
                          );
                        },
                        icon: Icon(Icons.info_outline, size: screenWidth * 0.035, color: ColorsManager.primaryColor),
                        label: Text("Details", style: TextStyle(color: ColorsManager.primaryColor, fontSize: screenWidth * 0.028)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: 0),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorited ? Icons.bookmark : Icons.bookmark_border,
                        size: screenWidth * 0.05,
                        color: ColorsManager.primaryColor,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.005),
            decoration: const BoxDecoration(
              color: ColorsManager.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.school, size: screenWidth * 0.038, color: Colors.white),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  "Course",
                  style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


