

// import 'package:flutter/material.dart';
// import '../../services/local_storage_service.dart';
// import '../onboarding/onboarding_screen.dart';
// import '../pages/login_signup/login_screen.dart';
// import '../pages/home/company_home.dart';
// import '../pages/home/center_home.dart';
// import '../pages/home/trainer_home.dart';
// import 'onBording/OnBording_Wrapper.dart';
//
// class RedirectorScreen extends StatelessWidget {
//   const RedirectorScreen({Key? key}) : super(key: key);
//
//   Future<Widget> _getInitialScreen() async {
//     final seenOnboarding = await LocalStorageService.hasSeenOnboarding();
//
//     if (!seenOnboarding) return const OnBoardingWrapper(); // ✅ أول مرة
//
//     final userData = await LocalStorageService.getLoginData();
//     if (userData == null) return const LoginScreen();
//
//     switch (userData['userType']) {
//       case 'trainee':
//         return const TraineeHomeScreen();
//       case 'company':
//         return const CompanyHomeScreen();
//       case 'center':
//         return const CenterHomeScreen();
//       case 'trainer':
//         return const TrainerHomeScreen();
//       default:
//         return const LoginScreen();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Widget>(
//       future: _getInitialScreen(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//         return snapshot.data!;
//       },
//     );
//   }
// }
