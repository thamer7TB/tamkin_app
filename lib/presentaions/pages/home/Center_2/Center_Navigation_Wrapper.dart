
import 'package:flutter/material.dart';
import '../../../../core/resorces/Colors_Manager.dart';
import 'screens/home_screen.dart'; // استبدلنا DashboardScreen بـ HomeScreen
import 'screens/profile_screen.dart';  // لاحقًا سنحدد الكود

class CenterNavigationWrapper extends StatefulWidget {
  const CenterNavigationWrapper({super.key});

  @override
  State<CenterNavigationWrapper> createState() => _CenterNavigationWrapperState();
}

class _CenterNavigationWrapperState extends State<CenterNavigationWrapper> {
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
    HomeScreen(), // الصفحة الرئيسية التي ستحتوي على لوحة التحكم
    ProfileScreen(),  // صفحة الملف الشخصي
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
            icon: Icon(Icons.dashboard),
            label: 'Dashboard', // الاسم يعكس الغرض
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}