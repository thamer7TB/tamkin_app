
import 'package:flutter/material.dart';
import '../../services/local_storage_service.dart';
import 'home/Center_2/Center_Navigation_Wrapper.dart';
import 'home/User_1/trainee_navigation_wrapper.dart';
import 'login_sginup_form/Login_With_Email_screen.dart';
import 'onBording/Login_Sginup_Onbording.dart';
import 'onBording/OnBording_Wrapper.dart';
// import '../pages/home/company_home.dart';
// import '../pages/home/center_home.dart';
// import '../pages/home/trainer_home.dart';
// import 'onBording/OnBording_Wrapper.dart';

class RedirectorScreen extends StatelessWidget {
  const RedirectorScreen({Key? key}) : super(key: key);

  Future<Widget> _getInitialScreen() async {
    final seenOnboarding = await LocalStorageService.hasSeenOnboarding();
    print('seenOnboarding: $seenOnboarding');

    if (!seenOnboarding) return const OnBoardingWrapper(); // ✅ أول مرة

    final userData = await LocalStorageService.getLoginData();
    print('userData: $userData');

    if (userData == null) return LoginWithEmailScreenScreen();

    final userType = userData['userType'];
    print('userType: $userType');

    switch (userType) {
      case 'users':
        return const TraineeNavigationWrapper();
      case 'training_centers':
        return const CenterNavigationWrapper();
      default:
        print('Redirecting to LoginWithEmailScreenScreen due to unrecognized userType');
        return LoginWithEmailScreenScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data!;
      },
    );
  }
}
