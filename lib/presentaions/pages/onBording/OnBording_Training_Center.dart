import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tamkin/core/resorces/Assets_Image_Manager.dart';
import 'package:tamkin/core/resorces/Colors_Manager.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';
import 'package:tamkin/core/resorces/Size_Value_Manager.dart';
import 'package:tamkin/core/resorces/Strings_Value_Manager.dart';

class OnBordingCenter extends StatelessWidget {
  final PageController controller;
  const OnBordingCenter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(child: Column (

        children: [

           SizedBox(height: screenHeight * 0.02 ,),
          Row (
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              TextButton( onPressed: () {
                Navigator.pushNamed(context, "LoginSginupOnbording");
              },
                child:  Align(alignment: Alignment.centerRight ,
                  child: Text(StringsManager.skip ,style:  TextStyle(color: ColorsManager.gray ,fontSize: screenWidth *0.049  , fontWeight: FontWeight.w400 , fontFamily: "Arial" ),),),
              ),
              SizedBox(width: screenWidth * 0.025 ,),
            ],
          ),

          SvgPicture.asset(ImagesManager.onBordingCenterImage,
            width : screenWidth ,
            height: screenHeight*0.5,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          // SizedBox(height: screenHeight*0.005 ,),

           Container ( // color: Colors.lightGreen ,
              width: double.infinity ,
              // height: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05),
              child: Column(
                  children: [
                    Align (
                      alignment: Alignment.centerLeft ,

                      child: Text(
                        StringsManager.onBordingTrainingCenterTitle ,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: screenWidth * 0.06 ,
                            color: ColorsManager.primaryColor,
                            fontWeight: FontWeight.bold, fontFamily:FontsManager.GEDinkum),

                      ),
                    ) ,
                    SizedBox(height: screenHeight * 0.01 ,),
                    Align (
                      alignment: Alignment.centerLeft ,
                      child: Text(
                        StringsManager.onBordingTrainingCenterDec,
                        textAlign: TextAlign.start ,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035 ,
                          color: ColorsManager.gray , ),

                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.01 ,),
                   // SizedBox(height: screenHeight * 0.01 ,),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: screenWidth * 0.05,
                          top: screenHeight * 0.02,
                        ),
                        child: SizedBox(
                          width: screenWidth * 0.14,
                          height: screenWidth * 0.14,
                          child: IconButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(ColorsManager.primaryColor),
                              shape: MaterialStateProperty.all(const CircleBorder()),
                            ),
                            onPressed: () {
                              if ( controller.page!.round() < 2) {
                                controller.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              } else {
                                Navigator.pushNamed(context , "LoginSginupOnbording");
                              }// الانتقال للصفحة التالية
                            },
                            icon: Icon(
                              Icons.arrow_forward,
                              color: ColorsManager.white ,
                              size: screenWidth * 0.065,
                            ),
                          ),
                        ),
                      ),
                    ) ,
                  ])
          ),
           Spacer(flex: FlexValueManager.flexValue2,),

        ],
      )),
    );
  }
}
