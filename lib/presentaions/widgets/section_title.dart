
import 'package:flutter/material.dart';
import '../../../core/resorces/Colors_Manager.dart';
import '../../../core/resorces/Fonts_Manager.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const SectionTitle({
    super.key,
    required this.title,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: w * 0.043,
              fontWeight: FontWeight.bold,
              color: ColorsManager.black.withOpacity(0.8),
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Row(
                children: [
                  Text(
                    "See all",
                    style: TextStyle(
                      fontSize: w * 0.035,
                      color: ColorsManager.black.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: ColorsManager.black.withOpacity(0.7)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
