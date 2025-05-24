
// lib/presentations/widgets/User_1/training_horizontal_list.dart
import 'package:flutter/material.dart';
import '../../../models/User_1/training_opportunity_model.dart';
import '../../../services/User_1/training_opportunity_service.dart';
import 'training_opportunity_card.dart';

class TrainingHorizontalList extends StatelessWidget {
  const TrainingHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    final TrainingOpportunityService _service = TrainingOpportunityService();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.36, // زيادة الارتفاع لضمان العرض الكامل
      child: FutureBuilder<List<TrainingOpportunityModel>>(
        future: _service.fetchTrainingOpportunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error in TrainingHorizontalList: ${snapshot.error}');
            return const Center(child: Text("Failed to load trainings."));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('No training opportunities available');
            return const Center(child: Text("No trainings available."));
          }

          final trainings = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            itemCount: trainings.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.01),
                child: SizedBox(
                  width: screenWidth * 0.65, // إضافة العرض الثابت هنا
                  child: TrainingOpportunityCard(training: trainings[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

