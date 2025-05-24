
import 'package:flutter/material.dart';
import '../../../core/resorces/Colors_Manager.dart';
import '../../../models/User_1/center_model.dart';

import '../pages/home/User_1/screens/Home_tab/Center_Profile_Screen.dart';

class CenterCard extends StatelessWidget {
  final CenterModel center;

  const CenterCard({Key? key, required this.center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    // تقييد عدد الأحرف في الاسم (مثلاً 12 حرفًا)
    String displayName = center.name.length > 12
        ? '${center.name.substring(0, 12)}...'
        : center.name;

    return SizedBox(
      width: w * 0.25,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CenterProfileScreen(centerId: center.id),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: w * 0.08,
              backgroundColor: Colors.grey[200],
              child: center.logoUrl.isNotEmpty
                  ? ClipOval(
                child: Image.network(
                  center.logoUrl,
                  fit: BoxFit.cover,
                  width: w * 0.16,
                  height: w * 0.16,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/center_placeholder.png',
                      fit: BoxFit.cover,
                      width: w * 0.16,
                      height: w * 0.16,
                    );
                  },
                ),
              )
                  : Image.asset(
                'assets/images/center_placeholder.png',
                fit: BoxFit.cover,
                width: w * 0.16,
                height: w * 0.16,
              ),
            ),
            SizedBox(height: w * 0.02),
            Text(
              displayName,
              style: TextStyle(
                fontSize: w * 0.04,
                fontWeight: FontWeight.w400,
                color: ColorsManager.primaryColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}