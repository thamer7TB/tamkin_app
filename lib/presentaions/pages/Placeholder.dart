

import 'package:flutter/material.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';

import '../../core/resorces/Colors_Manager.dart';

class FeatureUnavailableScreen extends StatelessWidget {
  final String title;

  const FeatureUnavailableScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: AppBar(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(15) , left: Radius.circular(15))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back , color: ColorsManager.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ColorsManager.primaryColor,
        title: Text(title , style: TextStyle(color: Colors.white ,fontFamily: FontsManager.GEDinkum , fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(screenWidth*0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_empty,
                size: screenWidth*0.22,
                color: Colors.grey[600],
              ),
               SizedBox(height: screenHeight*0.04),
               Text(
                'Coming soon!',
                style: TextStyle(
                  fontSize: screenWidth*0.067,
                  fontWeight: FontWeight.bold,
                ),
              ),
               SizedBox(height: screenHeight*0.02),
               Text(
                'This feature is temporarily unavailable.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth*0.043,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
