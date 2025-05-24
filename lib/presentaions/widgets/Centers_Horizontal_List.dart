
import 'package:flutter/material.dart';
import '../../../models/User_1/center_model.dart';
import '../../services/User_1/Get_Center_Service.dart';
import 'Center_Card_Screen.dart';

class CentersHorizontalList extends StatelessWidget {
  const CentersHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    final CenterService _service = CenterService();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.18, // ضبط الارتفاع للتصميم الجديد
      child: FutureBuilder<List<CenterModel>>(
        future: _service.fetchCenters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load centers."));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No centers available."));
          }

          final centers = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01), // تقليل الحواف
            itemCount: centers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.02), // تقليل المسافة بين العناصر
                child: CenterCard(center: centers[index]),
              );
            },
          );
        },
      ),
    );
  }
}