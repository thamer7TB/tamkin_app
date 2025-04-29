import 'package:flutter/material.dart';
import '../core/resorces/Routes_Manager.dart';
import '../presentaions/pages/Splash_Screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,

      initialRoute: "ProfileStartScreen" ,
      routes: RoutesManager.routs,

    );
  }
}
