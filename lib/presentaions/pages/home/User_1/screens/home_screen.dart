
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../services/local_storage_service.dart';
import '../../../../widgets/Centers_Horizontal_List.dart';
import '../../../../widgets/Courses_Horizantal_List.dart';
import '../../../../widgets/banners_horizontal_list.dart';
import '../../../../widgets/section_title.dart';
import '../../../../widgets/services_horizontal_list.dart';
import '../../../../widgets/training_horizontal_list.dart';
import 'Home_tab/All_Services_Screen.dart';
import 'explore_screen.dart';
import 'search_screen.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? lastName;
  int? notificationCount; // لاحقًا يمكن تحديثها بناءً على عدد الإشعارات
  FocusNode _focusNode = FocusNode();
  bool _isKeyboardVisible = false;
  ValueNotifier<String> _hintTextNotifier = ValueNotifier<String>('Search');
  List<String> _hints = [
    'Search',
    'Training Opportunities',
    'Training Centers',
    'Find Training Centers',
  ];
  final TextEditingController _searchController = TextEditingController(); // Added controller

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _startHintRotation();
  }

  Future<void> _loadUserData() async {
    final data = await LocalStorageService.getLoginData();
    if (data != null) {
      setState(() {
        lastName = data['lastName'];
      });
    }
  }

  void _startHintRotation() {
    int currentIndex = 0;
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        currentIndex = (currentIndex + 1) % _hints.length;
        _hintTextNotifier.value = _hints[currentIndex];
      }
    });
  }

  void _performSearch() { // Added search logic
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(searchQuery: query),
        ),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _hintTextNotifier.dispose();
    _searchController.dispose(); // Added disposal of controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorsManager.UserGrayScaffold,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // حاوية الترحيب مع الحقل البحث وأيقونة الإشعارات
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.03,
                  ),
                  decoration: const BoxDecoration(
                    color: ColorsManager.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hello ${lastName ?? 'User'}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => const NotificationsScreen(),
                                //   ),
                                // );
                              },
                              child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications,
                                  color: ColorsManager.primaryColor,
                                  size: screenWidth * 0.06,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        GestureDetector(
                          onTap: () {
                            _focusNode.requestFocus();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ValueListenableBuilder<String>(
                              valueListenable: _hintTextNotifier,
                              builder: (context, currentHint, child) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 500),
                                        transitionBuilder: (Widget child, Animation<double> animation) {
                                          return FadeTransition(opacity: animation, child: child);
                                        },
                                        child: TextField(
                                          key: ValueKey<String>(currentHint),
                                          focusNode: _focusNode,
                                          controller: _searchController, // Added controller
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                            hintText: currentHint,
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                          textInputAction: TextInputAction.search,
                                          onSubmitted: (value) => _performSearch(), // Added onSubmitted
                                          onTap: () {
                                            setState(() {
                                              _isKeyboardVisible = true;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _performSearch, // Replaced print logic with _performSearch
                                      child: SvgPicture.asset(
                                        'assets/images/icons/SearchIcon.svg',
                                        width: screenWidth * 0.07,
                                        height: screenHeight * 0.04,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // قسم BannersHorizontalList
                const BannersHorizontalList(),
                SizedBox(height: screenHeight * 0.005),
                // قسم ServicesHorizontalList
                SectionTitle(
                  title: 'Our Services',
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AllServicesScreen()),
                    );
                  },
                ),
                const ServicesHorizontalList(),
                SizedBox(height: screenHeight * 0.01),
                // قسم CentersHorizontalList (فرص التكوين)
                SectionTitle(
                  title: 'Training Opportunities',
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExploreScreen()),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.01),
                CoursesHorizontalList(),
                SizedBox(height: screenHeight * 0.01),
                // قسم TrainingHorizontalList (بروفايلات المراكز)
                SectionTitle(
                  title: 'Training Centers',
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExploreScreen()),
                    );
                  },
                ),
                const CentersHorizontalList(),
                // قسم TrainingHorizontalList (فرص التدريب)
                SectionTitle(
                  title: 'Training Opportunities',
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExploreScreen()),
                    );
                  },
                ),
                const TrainingHorizontalList(),
              ],
            ),
          ),
          if (_isKeyboardVisible)
            SafeArea(
              child: IgnorePointer(
                ignoring: false,
                child: Stack(
                  children: [
                    ModalBarrier(
                      color: Colors.black.withOpacity(0.5),
                      dismissible: true,
                      onDismiss: () {
                        setState(() {
                          _isKeyboardVisible = false;
                          _focusNode.unfocus();
                        });
                      },
                    ),
                    // حقل البحث يبقى مرئيًا وغير معتم
                    Positioned(
                      top: screenHeight * 0.1, // تحديد الموقع بناءً على ارتفاع الحاوية
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return FadeTransition(opacity: animation, child: child);
                                },
                                child: TextField(
                                  key: ValueKey<String>(_hintTextNotifier.value),
                                  focusNode: _focusNode,
                                  controller: _searchController, // Added controller
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                    hintText: _hintTextNotifier.value,
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (value) => _performSearch(), // Added onSubmitted
                                  onTap: () {
                                    setState(() {
                                      _isKeyboardVisible = true;
                                    });
                                  },
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _performSearch, // Replaced print logic with _performSearch
                              child: SvgPicture.asset(
                                'assets/images/icons/SearchIcon.svg',
                                width: screenWidth * 0.07,
                                height: screenHeight * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}