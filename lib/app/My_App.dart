import 'package:flutter/material.dart';
import '../core/resorces/Routes_Manager.dart';
import '../presentaions/pages/Splash_Screen.dart';
import '../presentaions/pages/redirector_screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,

    //  home: const RedirectorScreen(),
      initialRoute:  "TraineeHome",
      routes: RoutesManager.routs,

    );
  }
}
