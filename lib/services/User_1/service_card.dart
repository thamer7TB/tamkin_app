
import 'package:flutter/material.dart';
import '../../../core/resorces/Colors_Manager.dart';
import '../../../models/User_1/service_model.dart';
import '../../presentaions/pages/Placeholder.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;

  const ServiceCard({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return SizedBox(
      width: w * 0.25,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FeatureUnavailableScreen(title: service.title),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: w * 0.08,
              backgroundColor: ColorsManager.primaryColor.withOpacity(0.1),
              child: Icon(
                service.icon,
                size: w * 0.08,
                color: ColorsManager.primaryColor,
              ),
            ),
            SizedBox(height: w * 0.02),
            Text(
              service.title,
              style: TextStyle(
                fontSize: w * 0.035,
                fontWeight: FontWeight.bold,
                color: ColorsManager.primaryColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}