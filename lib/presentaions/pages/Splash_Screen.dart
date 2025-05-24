import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/resorces/Colors_Manager.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer ;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, " /redirector ");
    },);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold( backgroundColor: ColorsManager.primaryColor,
      body: SafeArea (child: Center(child: Image(image: AssetImage('assets/images/icons/app_icon.png'),))),
    );
  }
}