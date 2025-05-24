import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../models/User_1/center_model.dart';
import '../../../../../models/User_1/course_opportunity_model.dart';
import '../../../../../models/User_1/training_opportunity_model.dart';
import '../../../../../services/User_1/Get_Center_Service.dart';
import '../../../../../services/User_1/course_opportunity_service.dart';
import '../../../../../services/User_1/training_opportunity_service.dart';
import '../../../../widgets/Center_Card_Screen.dart';
import '../../../../widgets/course_opportunity_card.dart';
import '../../../../widgets/training_opportunity_card.dart';

class SearchScreen extends StatefulWidget {
  final String? searchQuery; // Added optional searchQuery parameter

  const SearchScreen({super.key, this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CourseOpportunityModel> _courseOpportunities = [];
  List<TrainingOpportunityModel> _trainingOpportunities = [];
  List<CenterModel> _centers = [];
  bool _isLoading = false;
  List<String> _searchHistory = [];
  String? _currentQuery;

  // Filter variables
  String _selectedType = 'All'; // Type filter (All, Courses, Training, Centers)
  String? _selectedDomain; // Domain filter
  String? _selectedWilaya; // City filter
  DateTime? _selectedStartDate; // Start date filter

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _loadSearchHistory();
    // Set initial search query from widget if provided
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      _searchController.text = widget.searchQuery!;
      _onSearchSubmitted(widget.searchQuery!);
    }
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final courseService = CourseOpportunityService();
      final trainingService = TrainingOpportunityService();
      final centerService = CenterService();

      _courseOpportunities = await courseService.fetchCourseOpportunities();
      _trainingOpportunities = await trainingService.fetchTrainingOpportunities();
      _centers = await centerService.fetchCenters();
    } catch (e) {
      print('Error loading initial data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('searchHistory', _searchHistory);
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      setState(() {
        if (!_searchHistory.contains(query)) {
          _searchHistory.insert(0, query);
          _saveSearchHistory();
        }
        _currentQuery = query;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _currentQuery = query.isEmpty ? null : query;
    });
  }

  void _removeSearchHistoryItem(String item) {
    setState(() {
      _searchHistory.remove(item);
      _saveSearchHistory();
    });
  }

  // Show filter dialog
  void _showFilterDialog() {
    String tempType = _selectedType;
    String? tempDomain = _selectedDomain;
    String? tempWilaya = _selectedWilaya;
    DateTime? tempStartDate = _selectedStartDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Filter Options',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type Filter
                const Text('Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: tempType,
                  isExpanded: true,
                  items: <String>['All', 'Courses', 'Training', 'Centers']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      tempType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Domain Filter
                const Text('Domain', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButton<String?>(
                  value: tempDomain,
                  hint: const Text('Select Domain'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('Any')),
                    ..._courseOpportunities
                        .map((course) => course.domain)
                        .toSet()
                        .map<DropdownMenuItem<String>>((domain) {
                      return DropdownMenuItem<String>(
                        value: domain,
                        child: Text(domain),
                      );
                    }),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      tempDomain = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Wilaya Filter
                const Text('City', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButton<String?>(
                  value: tempWilaya,
                  hint: const Text('Select City'),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('Any')),
                    ..._courseOpportunities
                        .map((course) => course.wilaya)
                        .toSet()
                        .map<DropdownMenuItem<String>>((wilaya) {
                      return DropdownMenuItem<String>(
                        value: wilaya,
                        child: Text(wilaya),
                      );
                    }),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      tempWilaya = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Start Date Filter
                const Text('Start Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: tempStartDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        tempStartDate = picked;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    tempStartDate == null
                        ? 'Select Start Date'
                        : '${tempStartDate!.day}/${tempStartDate!.month}/${tempStartDate!.year}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  tempType = 'All';
                  tempDomain = null;
                  tempWilaya = null;
                  tempStartDate = null;
                });
              },
              child: const Text('Reset', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedType = tempType;
                  _selectedDomain = tempDomain;
                  _selectedWilaya = tempWilaya;
                  _selectedStartDate = tempStartDate;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Apply', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchHistory() {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Recent Searches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.3,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              final searchItem = _searchHistory[index];
              return ListTile(
                title: Text(searchItem),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => _removeSearchHistoryItem(searchItem),
                ),
                onTap: () {
                  _searchController.text = searchItem;
                  _onSearchSubmitted(searchItem);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions() {
    final query = _currentQuery?.toLowerCase() ?? '';
    List<String> suggestions = [];

    suggestions.addAll(_courseOpportunities
        .map((course) => course.courseTitle)
        .where((title) => title.toLowerCase().contains(query)));
    suggestions.addAll(_trainingOpportunities
        .map((training) => training.title)
        .where((title) => title.toLowerCase().contains(query)));
    suggestions.addAll(_centers
        .map((center) => center.name)
        .where((name) => name.toLowerCase().contains(query)));

    return suggestions.isEmpty
        ? const Center(child: Text("No suggestions found"))
        : ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            _searchController.text = suggestion;
            _onSearchSubmitted(suggestion);
          },
        );
      },
    );
  }

  Widget _buildSearchResults() {
    final query = _searchController.text.toLowerCase(); // Use _searchController.text for manual input
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;

    if (_currentQuery == null || query.isEmpty) {
      return _searchHistory.isEmpty
          ? const Center(child: Text("Start searching..."))
          : _buildSearchHistory();
    }

    if (_currentQuery != _searchController.text) {
      return _buildSuggestions();
    }

    List<Widget> courseAndTrainingCards = [];
    List<Widget> centerCards = [];

    // Apply filters
    if (_selectedType == 'All' || _selectedType == 'Courses') {
      var filteredCourses = _courseOpportunities.where((course) {
        // Parse startDate from String to DateTime
        DateTime? courseStartDate;
        try {
          if (course.startDate != null && course.startDate!.isNotEmpty) {
            courseStartDate = DateTime.parse(course.startDate!);
          }
        } catch (e) {
          print('Error parsing startDate for course: $e');
        }

        return (course.courseTitle.toLowerCase().contains(query) ||
            course.centerName.toLowerCase().contains(query) ||
            course.domain.toLowerCase().contains(query) ||
            course.wilaya.toLowerCase().contains(query)) &&
            (_selectedDomain == null || course.domain == _selectedDomain) &&
            (_selectedWilaya == null || course.wilaya == _selectedWilaya) &&
            (_selectedStartDate == null ||
                (courseStartDate != null &&
                    courseStartDate.year == _selectedStartDate!.year &&
                    courseStartDate.month == _selectedStartDate!.month &&
                    courseStartDate.day == _selectedStartDate!.day));
      });
      courseAndTrainingCards.addAll(filteredCourses.map((course) => CourseOpportunityCard(course: course)));
    }

    if (_selectedType == 'All' || _selectedType == 'Training') {
      var filteredTraining = _trainingOpportunities.where((training) {
        // Parse startDate from String to DateTime
        DateTime? trainingStartDate;
        try {
          if (training.startDate != null && training.startDate!.isNotEmpty) {
            trainingStartDate = DateTime.parse(training.startDate!);
          }
        } catch (e) {
          print('Error parsing startDate for training: $e');
        }

        return (training.title.toLowerCase().contains(query) ||
            training.companyName.toLowerCase().contains(query) ||
            training.domain.toLowerCase().contains(query) ||
            training.wilaya.toLowerCase().contains(query)) &&
            (_selectedDomain == null || training.domain == _selectedDomain) &&
            (_selectedWilaya == null || training.wilaya == _selectedWilaya) &&
            (_selectedStartDate == null ||
                (trainingStartDate != null &&
                    trainingStartDate.year == _selectedStartDate!.year &&
                    trainingStartDate.month == _selectedStartDate!.month &&
                    trainingStartDate.day == _selectedStartDate!.day));
      });
      courseAndTrainingCards.addAll(filteredTraining.map((training) => TrainingOpportunityCard(training: training)));
    }

    if (_selectedType == 'All' || _selectedType == 'Centers') {
      var filteredCenters = _centers.where((center) =>
          center.name.toLowerCase().contains(query));
      centerCards.addAll(filteredCenters.map((center) => CenterCard(center: center)));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (courseAndTrainingCards.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Courses & Training Opportunities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              padding: EdgeInsets.all(screenWidth * 0.02),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth * 0.02,
                mainAxisSpacing: screenHeight * 0.02,
                childAspectRatio: 0.6,
              ),
              itemCount: courseAndTrainingCards.length,
              itemBuilder: (context, index) => courseAndTrainingCards[index],
            ),
          ],
          if (centerCards.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Centers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              padding: EdgeInsets.all(screenWidth * 0.02),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth * 0.02,
                mainAxisSpacing: screenHeight * 0.02,
                childAspectRatio: 0.6,
              ),
              itemCount: centerCards.length,
              itemBuilder: (context, index) => centerCards[index],
            ),
          ],
          if (courseAndTrainingCards.isEmpty && centerCards.isEmpty)
            Center(child: Text('No results found for "$query"')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width; // Corrected to screenHeight
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorsManager.UserGrayScaffold,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: screenWidth * 0.12, bottom: screenWidth * 0.05),
            decoration: const BoxDecoration(
              color: ColorsManager.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    // Search field container
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.001),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Search for anything',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                                ),
                                textInputAction: TextInputAction.search,
                                onChanged: _onSearchChanged,
                                onSubmitted: _onSearchSubmitted,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _onSearchSubmitted(_searchController.text),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.search, color: ColorsManager.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Filter icon outside the search field
                    SizedBox(width: screenWidth * 0.005), // Spacing between search field and filter icon
                    GestureDetector(
                      onTap: _showFilterDialog,
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: Icon(
                          Icons.filter_list,
                          color: Colors.white, // Changed to white to match the background
                          size: screenWidth * 0.08,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }
}