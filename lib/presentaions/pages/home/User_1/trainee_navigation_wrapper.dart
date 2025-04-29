
import 'package:flutter/material.dart';
import '../../../../core/resorces/Colors_Manager.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/account_screen.dart';

class TraineeNavigationWrapper extends StatefulWidget {
  const TraineeNavigationWrapper({super.key});

  @override
  State<TraineeNavigationWrapper> createState() => _TraineeNavigationWrapperState();
}

class _TraineeNavigationWrapperState extends State<TraineeNavigationWrapper> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    ExploreScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: _screens,
        physics: const BouncingScrollPhysics(), // يسمح بالسحب الجميل
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: ColorsManager.primaryColor,
        unselectedItemColor: Colors.black87,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

