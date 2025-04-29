

import 'package:flutter/material.dart';

import '../../../core/resorces/Colors_Manager.dart';
import '../../../core/resorces/Size_Value_Manager.dart';

class WhoAreYouScreen extends StatefulWidget {
  @override
  _WhoAreYouScreenState createState() => _WhoAreYouScreenState();
}

class _WhoAreYouScreenState extends State<WhoAreYouScreen> {
  int? selectedOption;
  final Map<int, Map<String, dynamic>> options = {
    1: {
      'title': 'Trainee/Training Seeker',
      'description': 'I\'m a student, graduate, or artisan looking for training or internship opportunities.',
      'icon': Icons.school,
      'route': "TraineeSignupScreen",
    },
    2: {
      'title': 'Company/Employer',
      'description': 'We are a company or organization offering internship or work-based training opportunities.',
      'icon': Icons.business_sharp,
      'route': "CompanySignupScreen",
    },
    3: {
      'title': 'Training Center/Institution',
      'description': 'We provide structured training programs and seek suitable candidates.',
      'icon': Icons.business_center_rounded,
      'route': "CenterSignupScreen",
    },
    4: {
      'title': 'Trainer/Course Provider',
      'description': 'I provide courses or training programs and would like to collaborate with training centers or train individuals directly.',
      'icon': Icons.person,
      'route': "TrainerSignupScreen",
    },
  };

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea (
        child: Stack (
          children: [
            Positioned(
                top: 0,
                right: 0,
                child: Image.asset("assets/images/onbording/main_top_rghit.png" , scale: 0.9,)
            ),
            Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset("assets/images/onbording/main_bottom_left.png" ,scale:1.5, )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                SizedBox(width: screenWidth*0.02,),
                Align (
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(ColorsManager.transparent),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: ColorsManager.primaryColor ,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ),
              ],),
              Text(
                "Who Are you?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric( horizontal:  screenWidth *0.05 , vertical: screenHeight * 0.03),
                  itemCount: options.length,
                  //card options 🔽🔽
                  itemBuilder: (context, index) {
                    int key = index + 1;
                    return Card(
                      margin:  EdgeInsets.symmetric( vertical: screenHeight * 0.006),
                      color: selectedOption == key ? Colors.blue[50] : Colors.white,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedOption = key;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(screenHeight*0.018),
                          child: Row(
                            children: [
                              Icon(
                                options[key]!['icon'],
                                size: screenWidth*0.15,
                                color: selectedOption == key ? Colors.blue : Colors.grey,
                              ),
                              SizedBox (width: screenWidth*0.03),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${key}. ${options[key]!['title']}',
                                      style: TextStyle(
                                        fontSize: screenWidth*0.043,
                                        fontWeight: FontWeight.bold,
                                        color: selectedOption == key ? Colors.blue : Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight*0.012),
                                    Text(options[key]!['description']),
                                  ],
                                ),
                              ),
                              if (selectedOption == key)
                                const Icon(Icons.check_circle, color: Colors.green),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Next Button 🔽🔽
              Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.primaryColor ,
                        shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular( RadiusManager.rounded30),
                                 ),
                          padding: EdgeInsets.symmetric(
                           vertical: screenHeight * 0.013),
                            ),
                           onPressed: selectedOption != null
                          ? () {
                           Navigator.pushNamed(
                           context, options[selectedOption]!['route']);
                           }
                            : null,
                             child: Text(
                               "Next" ,
                              style: TextStyle(
                              color: ColorsManager.white,
                               fontSize: screenWidth * 0.05,
                               fontWeight: FontWeight.bold,
                                 ),
              )
         ))),
              SizedBox(height: screenHeight*0.04,),
    ],
    ),
          ]
        ),
      ),
    );
  }
}