
// lib/presentations/widgets/User_1/training_details_screen.dart
import 'package:flutter/material.dart';
import '../../../core/resorces/Colors_Manager.dart';
import '../../../core/resorces/Fonts_Manager.dart';
import '../../../models/User_1/training_opportunity_model.dart';
import 'Custom_Button.dart';

class TrainingDetailsScreen extends StatelessWidget {
  final TrainingOpportunityModel training;

  const TrainingDetailsScreen({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorsManager.UserGrayScaffold,
      appBar: AppBar(
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
          'Training Details',
          style: TextStyle(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: FontsManager.GEDinkum,
            fontSize: w * 0.05,
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(w * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شعار الشركة + اسمها
            GestureDetector(
              onTap: () {
                // TODO: الانتقال إلى صفحة بروفايل الشركة عند التفعيل
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Company profile coming soon')),
                // );
              },
              child: Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w * 0.03),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: w * 0.01,
                      offset: Offset(0, h * 0.005),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding:  EdgeInsets.all(w*0.005),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorsManager.primaryColor, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: w * 0.1,
                        backgroundColor: Colors.grey[200],
                        child: training.logoUrl.isNotEmpty
                            ? ClipOval(
                          child: Image.network(
                            training.logoUrl,
                            fit: BoxFit.cover,
                            width: w * 0.2,
                            height: w * 0.2,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('Failed to load image: ${training.logoUrl}, error: $error');
                              return Image.asset(
                                'assets/images/center_placeholder.png',
                                fit: BoxFit.cover,
                                width: w * 0.2,
                                height: w * 0.2,
                              );
                            },
                          ),
                        )
                            : Image.asset(
                          'assets/images/center_placeholder.png',
                          fit: BoxFit.cover,
                          width: w * 0.2,
                          height: w * 0.2,
                        ),
                      ),
                    ),
                     SizedBox(height: w * 0.04),
                    Align(
                      child: Text(
                            training.companyName,
                            style: TextStyle(
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsManager.GEDinkum,
                              color: ColorsManager.primaryColor,
                            ),
                          ),),
                           SizedBox(height: h * 0.005),
                          Align (
                            child: Text(
                              training.wilaya,
                              style: TextStyle(fontSize: w * 0.04, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            SizedBox(height: h * 0.02),
            // تفاصيل التدريب
            Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(w * 0.03),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: w * 0.01,
                    offset: Offset(0, h * 0.005),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: w * 0.065, color: ColorsManager.gray),
                      SizedBox(width: w * 0.04),
                      Text(
                        'Training Details',
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsManager.GEDinkum,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.01),
                  _buildDetailRow(context, Icons.location_on, 'Location', training.wilaya),
                  _buildDetailRow(context, Icons.category, 'Domain', training.domain),
                  _buildDetailRow(context, Icons.schedule, 'Duration', training.duration),
                  _buildDetailRow(context, Icons.calendar_today, 'Start Date', training.startDate),
                ],
              ),
            ),
            SizedBox(height: h * 0.02),
            // وصف التدريب
            Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(w * 0.03),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: w * 0.01,
                    offset: Offset(0, h * 0.005),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description_outlined, size: w * 0.065, color: ColorsManager.gray),
                      SizedBox(width: w * 0.04),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsManager.GEDinkum,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    training.description.isNotEmpty ? training.description : 'No description provided.',
                    style: TextStyle(fontSize: w * 0.038, height: 1.5, color: Colors.grey[700]),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.02),
            // الشروط
            Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(w * 0.03),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: w * 0.01,
                    offset: Offset(0, h * 0.005),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.list_alt_outlined, size: w * 0.065, color: ColorsManager.gray),
                      SizedBox(width: w * 0.04),
                      Text(
                        'Requirements',
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsManager.GEDinkum,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    training.requirements.isNotEmpty ? training.requirements : 'No requirements provided.',
                    style: TextStyle(fontSize: w * 0.038, height: 1.5, color: Colors.grey[700]),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.05),
            // زر التقديم
            CustomButton(
              buttonText: 'Apply Now',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Application feature coming soon')),
                );
              },
            ),
            SizedBox(height: h * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String title, String value) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ColorsManager.primaryColor, size: w * 0.055),
          SizedBox(width: w * 0.04),
          Text(
            '$title:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: w * 0.038),
          ),
          SizedBox(width: w * 0.02),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: TextStyle(fontSize: w * 0.038, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}


