import 'package:flutter/material.dart';
import '../core/resorces/Routes_Manager.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,

    //  home: const RedirectorScreen(),
      initialRoute: "SplashScreen",
      routes: RoutesManager.routs,

    );
  }
}
