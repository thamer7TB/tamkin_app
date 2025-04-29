
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:tamkin/core/resorces/Size_Value_Manager.dart';
import '../../../core/resorces/Assets_Image_Manager.dart';
import '../../../core/resorces/Colors_Manager.dart';
import '../../../core/resorces/Fonts_Manager.dart';
import '../../../core/resorces/Strings_Value_Manager.dart';


class LoginSginupOnbording extends StatelessWidget {
  const LoginSginupOnbording ({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return  Scaffold(
    body: SafeArea(
    child: Column(
    children: [
    SizedBox(height: screenHeight * 0.02 ,),
      SvgPicture.asset(ImagesManager.onBordingLoginSginUpImage,
        width : screenWidth ,
        height: screenHeight*0.55,
        fit: BoxFit.contain,
      ),
     // SizedBox(height: screenHeight*0.01 ,),
        Text(
            StringsManager.onBordingLoginSginUpTitle ,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: screenWidth * 0.07 ,
                color: ColorsManager.primaryColor,
                fontWeight: FontWeight.w900, fontFamily:FontsManager.GEDinkum),),
      Spacer(flex: FlexValueManager.flexValue1,),
        Text(
            StringsManager.onBordingLoginSginUpDec,
            textAlign: TextAlign.center ,
            style: TextStyle(
              fontSize: screenWidth * 0.035 ,
              color: ColorsManager.gray , ),) ,
        Spacer(flex: FlexValueManager.flexValue5,),
        Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: screenWidth*0.04),
              Expanded (
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(RadiusManager.rounded30),
                        ),
                        padding:  EdgeInsets.symmetric(
                            vertical: screenHeight*0.017 )),
                    onPressed: () {
                      Navigator.pushNamed(context, "LoginWithEmailScreenScreen");
                    },
                    child:  Text(
                      StringsManager.login,
                      style: TextStyle(color:ColorsManager.white, fontSize: screenWidth * 0.041 ,fontWeight: FontWeight.bold ,  fontFamily:FontsManager.GEDinkum ),
                    )),
              ),
              SizedBox(width: screenWidth*0.04),
              Expanded (
                child: OutlinedButton(
                    style:  OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(RadiusManager.rounded30)
                        ),
                        padding: EdgeInsets.symmetric( vertical: screenHeight*0.019 )
                    ),
                    onPressed: () {
                       Navigator.pushNamed(context, "CardChooseUserType");
                    },
                    child:  Text(StringsManager.rigister , style: TextStyle(fontWeight: FontWeight.bold,  fontFamily:FontsManager.GEDinkum , fontSize: screenWidth * 0.035, color: ColorsManager.black),)),
              ),
              SizedBox(width: screenWidth*0.04),
              ]),
        Spacer(flex: FlexValueManager.flexValue5,),
  ])),
    );
  }
}
