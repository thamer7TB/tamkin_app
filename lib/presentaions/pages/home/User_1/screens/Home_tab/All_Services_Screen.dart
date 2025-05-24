
import 'package:flutter/material.dart';
import '../../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../widgets/services_horizontal_list.dart';
import '../../../../Placeholder.dart';
 // استيراد القائمة

class AllServicesScreen extends StatelessWidget {
  const AllServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorsManager.UserGrayScaffold,
      appBar: AppBar(
        title: const Text(
          'All Services',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorsManager.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // عدد الأعمدة
            crossAxisSpacing: 15, // المسافة الأفقية بين العناصر
            mainAxisSpacing: 15, // المسافة العمودية بين العناصر
            childAspectRatio: 0.8, // نسبة العرض إلى الارتفاع
          ),
          itemCount: ServicesHorizontalList.services.length,
          itemBuilder: (context, index) {
            final service = ServicesHorizontalList.services[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeatureUnavailableScreen(
                      title: service.title,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      service.icon,
                      size: screenWidth * 0.12,
                      color: ColorsManager.primaryColor,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      service.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}