import 'package:flutter/material.dart';
import '../../../../../core/resorces/Colors_Manager.dart';

class CourseOpportunityCard extends StatefulWidget {
  final String courseTitle;
  final String centerName;
  final String logoUrl;
  final String wilaya;
  final String startDate;
  final String domain;
  final String description;

  const CourseOpportunityCard({
    Key? key,
    required this.courseTitle,
    required this.centerName,
    required this.logoUrl,
    required this.wilaya,
    required this.startDate,
    required this.domain,
    required this.description,
  }) : super(key: key);

  @override
  State<CourseOpportunityCard> createState() => _CourseOpportunityCardState();
}

class _CourseOpportunityCardState extends State<CourseOpportunityCard> {
  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/courseDetails',
          arguments: {
            'courseTitle': widget.courseTitle,
            'centerName': widget.centerName,
            'logoUrl': widget.logoUrl,
            'wilaya': widget.wilaya,
            'startDate': widget.startDate,
            'domain': widget.domain,
            'description': widget.description,
          },
        );
      },
      child: Container(
        width: screenWidth * 0.65, // عرض ثابت لتناسق التصميم
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.01),
        padding: EdgeInsets.all(screenWidth * 0.03),
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
          mainAxisSize: MainAxisSize.min, // تأكيد أن الارتفاع يتكيف مع المحتوى
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: screenWidth * 0.07,
                backgroundImage: NetworkImage(widget.logoUrl),
                backgroundColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Center Name
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.centerName,
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  color: Colors.black87,
                ),
                maxLines: 1, // تحديد عدد الأسطر
                overflow: TextOverflow.ellipsis, // التعامل مع النصوص الطويلة
              ),
            ),
            SizedBox(height: screenHeight * 0.008),
            // Title
            Text(
              widget.courseTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenWidth * 0.041,
                fontWeight: FontWeight.bold,
                color: ColorsManager.primaryColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Domain and Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: screenWidth * 0.045, color: ColorsManager.primaryColor),
                      SizedBox(width: screenWidth * 0.01),
                      Expanded(
                        child: Text(
                          widget.wilaya,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey[700],
                          ),
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
                      Icon(Icons.category_outlined, size: screenWidth * 0.045, color: ColorsManager.primaryColor),
                      SizedBox(width: screenWidth * 0.01),
                      Expanded(
                        child: Text(
                          widget.domain,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey[700],
                          ),
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
            // Start Date
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: screenWidth * 0.045, color: ColorsManager.primaryColor),
                SizedBox(width: screenWidth * 0.011),
                Expanded(
                  child: Text(
                    'Starts on: ${widget.startDate}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // الدخول للتفاصيل
                  },
                  icon: Icon(Icons.info_outline, size: screenWidth * 0.04, color: ColorsManager.primaryColor),
                  label: Text(
                    "Details",
                    style: TextStyle(color: ColorsManager.primaryColor, fontSize: screenWidth * 0.03),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                  ),
                ),
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    _isFavorited ? Icons.bookmark : Icons.bookmark_border,
                    size: screenWidth * 0.06,
                    color: ColorsManager.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
