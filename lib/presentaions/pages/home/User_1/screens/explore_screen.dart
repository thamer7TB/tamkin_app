import 'package:flutter/material.dart';

import '../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../mock/mock_data.dart';
import '../../../../../mock/training_mock_data.dart';
import '../../../../../models/User_1/center_model.dart';
import '../../../../../models/User_1/course_opportunity_model.dart';
import '../../../../../models/User_1/training_opportunity_model.dart';
import '../../../../widgets/Center_Card_Screen.dart';
import '../../../../widgets/course_opportunity_card.dart';
import '../../../../widgets/training_opportunity_card.dart';


class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Courses',
    'Training',
    'Centers',
    'Nearest',
    'Shortest Duration',
    'Longest Duration',
    'With Certificate',
  ];

  // Mock data from provided files
  List<CourseOpportunityModel> _courseOpportunities = mockCourses.sublist(0, 15); // Take first 15 to avoid duplicates
  List<TrainingOpportunityModel> _trainingOpportunities = mockTrainings;
  List<CenterModel> _centers = mockCentersList.sublist(0, 15); // Take first 15 to avoid duplicates
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isLoading = false);
  }

  Widget _buildFilteredContent() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List<Widget> filteredCards = [];

    if (_selectedFilter == 'All' || _selectedFilter == 'Courses') {
      var filteredCourses = List<CourseOpportunityModel>.from(_courseOpportunities);

      if (_selectedFilter == 'Nearest') {
        // Placeholder for nearest filter (requires location data)
      } else if (_selectedFilter == 'Shortest Duration') {
        // Placeholder (needs endDate or duration field)
      } else if (_selectedFilter == 'Longest Duration') {
        // Placeholder (needs endDate or duration field)
      } else if (_selectedFilter == 'With Certificate') {
        filteredCourses = filteredCourses.where((course) => course.isSaved).toList();
      }

      if (_selectedFilter == 'Courses' || _selectedFilter == 'All') {
        filteredCards.addAll(filteredCourses.map((course) => CourseOpportunityCard(course: course)));
      }
    }

    if (_selectedFilter == 'All' || _selectedFilter == 'Training') {
      var filteredTraining = List<TrainingOpportunityModel>.from(_trainingOpportunities);

      if (_selectedFilter == 'Nearest') {
        // Placeholder for nearest filter (requires location data)
      } else if (_selectedFilter == 'Shortest Duration') {
        filteredTraining.sort((a, b) {
          int aDuration = int.tryParse(a.duration!.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          int bDuration = int.tryParse(b.duration!.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          return aDuration.compareTo(bDuration);
        });
      } else if (_selectedFilter == 'Longest Duration') {
        filteredTraining.sort((a, b) {
          int aDuration = int.tryParse(a.duration!.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          int bDuration = int.tryParse(b.duration!.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          return bDuration.compareTo(aDuration);
        });
      } else if (_selectedFilter == 'With Certificate') {
        filteredTraining = filteredTraining.where((training) => training.isSaved).toList();
      }

      if (_selectedFilter == 'Training' || _selectedFilter == 'All') {
        filteredCards.addAll(filteredTraining.map((training) => TrainingOpportunityCard(training: training)));
      }
    }

    if (_selectedFilter == 'All' || _selectedFilter == 'Centers') {
      var filteredCenters = List<CenterModel>.from(_centers);

      if (_selectedFilter == 'Nearest') {
        // Placeholder for nearest filter (requires location data)
      }

      if (_selectedFilter == 'Centers' || _selectedFilter == 'All') {
        filteredCards.addAll(filteredCenters.map((center) => CenterCard(center: center)));
      }
    }

    return Expanded(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredCards.isEmpty
          ? const Center(child: Text('No data found'))
          : GridView.builder(
        padding: EdgeInsets.all(screenWidth * 0.02),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: screenWidth * 0.02,
          mainAxisSpacing: screenHeight * 0.02,
          childAspectRatio: 0.6,
        ),
        itemCount: filteredCards.length,
        itemBuilder: (context, index) => filteredCards[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.UserGrayScaffold,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    bool isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        child: Chip(
                          label: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: isSelected
                              ? ColorsManager.primaryColor
                              : Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            _buildFilteredContent(),
          ],
        ),
      ),
    );
  }
}