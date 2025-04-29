
import 'package:flutter/material.dart';
import 'package:tamkin/presentaions/pages/login_sginup_form/Login_With_Email_screen.dart';
import '../../presentaions/pages/login_sginup_form/Center_3/Center_Signup_Screen.dart';
import '../../presentaions/pages/login_sginup_form/Chosse_User_Type_screen.dart';
import '../../presentaions/pages/login_sginup_form/Company_2/Company_Signup_Screen.dart';
import '../../presentaions/pages/login_sginup_form/Login_With_Phone_screen.dart';
import '../../presentaions/pages/login_sginup_form/Trainer_4/Trainer_Signup_Screen.dart';
import '../../presentaions/pages/login_sginup_form/User_1/Profile_Start_Form_Screen.dart';
import '../../presentaions/pages/login_sginup_form/User_1/Trainee_Signup_Screen.dart';
import '../../presentaions/pages/onBording/Login_Sginup_Onbording.dart';
import '../../presentaions/pages/onBording/OnBording_Company.dart';
import '../../presentaions/pages/onBording/OnBording_Wrapper.dart';


class RoutesManager {

  static Map <String, WidgetBuilder> get routs => {

    "/" : ( context ) => const OnBoardingWrapper(),
    "LoginSginupOnbording" : ( context ) => const LoginSginupOnbording(),
    "LoginWithEmailScreenScreen" : ( context ) =>  LoginWithEmailScreenScreen(),
    "LoginWithPhoneScreen" : ( context ) =>  LoginWithPhoneScreen(),
    "CardChooseUserType" : ( context ) =>  WhoAreYouScreen(),
    "TraineeSignupScreen" : ( context ) =>  TraineeSignupScreen(),
    "CompanySignupScreen" : ( context ) =>  CompanySignupScreen(),
    "CenterSignupScreen" : ( context ) =>  CenterSignupScreen(),
    "TrainerSignupScreen" : ( context ) =>  TrainerSignupScreen(),
    "ProfileStartScreen" : ( context ) =>  ProfileScreen(),


  };

}