
import 'package:flutter/material.dart';
import 'package:tamkin/presentaions/pages/login_sginup_form/Login_With_Email_screen.dart';
import '../../models/User_1/course_opportunity_model.dart';
import '../../presentaions/pages/Placeholder.dart';
import '../../presentaions/pages/home/User_1/screens/Account_tab/Settings_Screen.dart';
import '../../presentaions/pages/home/User_1/trainee_navigation_wrapper.dart';
import '../../presentaions/pages/login_sginup_form/Center_3/Center_Form_Screen.dart';
import '../../presentaions/pages/login_sginup_form/Center_3/Center_Signup_Screen.dart';
import '../../presentaions/pages/login_sginup_form/Chosse_User_Type_screen.dart';
import '../../presentaions/pages/login_sginup_form/Company_2/Company_Form_Screen.dart';
import '../../presentaions/pages/login_sginup_form/Company_2/Company_Signup_Screen.dart';
import '../../presentaions/pages/login_sginup_form/Login_With_Phone_screen.dart';
import '../../presentaions/pages/login_sginup_form/Trainer_4/Trainer_Signup_Screen.dart';
import '../../presentaions/pages/login_sginup_form/Trainer_4/trainer_form.dart';
import '../../presentaions/pages/login_sginup_form/User_1/Profile_Start_Form_Screen.dart';
import '../../presentaions/pages/login_sginup_form/User_1/Trainee_Signup_Screen.dart';
import '../../presentaions/pages/login_sginup_form/forget password/Forget_Password_With_Email_1_.dart';
import '../../presentaions/pages/onBording/Login_Sginup_Onbording.dart';
import '../../presentaions/pages/onBording/OnBording_Company.dart';
import '../../presentaions/pages/onBording/OnBording_Wrapper.dart';
import '../../presentaions/widgets/Course_Details_Screen.dart';


class RoutesManager {

  static Map <String, WidgetBuilder> get routs => {

    "/" : ( context ) => const OnBoardingWrapper(),
    "LoginSginupOnbording" : ( context ) => const LoginSginupOnbording(),
    "LoginWithEmailScreenScreen" : ( context ) =>  LoginWithEmailScreenScreen(),
    "LoginWithPhoneScreen" : ( context ) =>  LoginWithPhoneScreen(),
    "CardChooseUserType" : ( context ) =>  WhoAreYouScreen(),
    "TraineeSignupScreen" : ( context ) =>  TraineeSignupScreen(),
    "TrainingCenterSignupScreen" : ( context ) =>  TrainingCenterSignupScreen(),
    "TrainerSignupScreen" : ( context ) =>  TrainerSignupScreen(),
    "ProfileStartScreen" : ( context ) =>  ProfileScreen(),
    "ForgetPasswordScreen1" : ( context ) =>  ForgetPasswordScreen1(),
    "CompanySignupScreen" : ( context ) =>  CompanySignupScreen(),
    "CompanyFormScreen" : ( context ) =>  CompanyProfileScreen(),
    "TrainingCenterFormScreen" : ( context ) =>  TrainingCenterFormScreen(),
    "TrainerFormScreen" : ( context ) =>  TrainerFormScreen(),
    "TraineeHome": (context) => const TraineeNavigationWrapper(),

    // User 1
         // ----------> Account Navigation all services

    "SettingsScreen": (context) => const SettingsScreen(),

    // User 1
    // ----------> Home Navigation all services

    '/courseDetails': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as CourseOpportunityModel;
      return CourseDetailsScreen(course: args);
    },


  };

}