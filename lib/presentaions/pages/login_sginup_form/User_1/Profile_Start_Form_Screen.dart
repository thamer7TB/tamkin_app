import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tamkin/core/resorces/Colors_Manager.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';
import 'package:http/http.dart' as http;
import 'package:tamkin/models/System_Data.dart';
import 'package:tamkin/models/User_1/profile_model.dart';
import 'package:tamkin/services/local_storage_service.dart';
import '../../../../services/User_1/profile_service.dart';
import '../../../widgets/File_Upload_widget.dart';
import '../../../widgets/Profile_Picture_Widjet.dart';
import '../Login_With_Email_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, String> signupData;

  ProfileScreen({required this.signupData});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final ProfileModel _profile = ProfileModel();

  Future<void> _submitForm() async {
    if (_profile.firstName.isEmpty ||
        _profile.lastName.isEmpty ||
        _profile.dateOfBirth == null ||
        _profile.wilaya == null ||
        _profile.commune.isEmpty ||
        _profile.street.isEmpty ||
        _profile.educationLevel == null ||
        _profile.interests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete all required fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      print('🔍 Starting _submitForm in ProfileScreen');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      final profileService = ProfileService();
      final response = await profileService.submitProfile(
        _profile,
        signupData: widget.signupData,
      );

      Navigator.of(context).pop();

      print('📥 Response from ProfileService: $response');

      if (response != null) {
        print('✅ Profile saved successfully in ProfileScreen!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile saved successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginWithEmailScreenScreen()),
        );
      } else {
        final errorMessage = response != null
            ? response['error'] ?? 'Unknown server error'
            : 'Failed to save profile: Server error';
        print('❌ Failed to save profile in ProfileScreen: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $errorMessage')),
        );
      }
    } catch (e) {
      print('❌ Error during submission in ProfileScreen: $e');
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _profile.dateOfBirth) {
      setState(() {
        _profile.dateOfBirth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('----- Building UI -----');
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Complete Your Profile',
          style: TextStyle(
            color: ColorsManager.primaryColor,
            fontFamily: FontsManager.GEDinkum,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildPersonalInfoPage(),
                _buildLocationPage(),
                _buildEducationPage(),
                _buildDocumentsPage(),
              ],
            ),
          ),
          _buildPageIndicator(),
          _buildNavigationButtons(),
          SizedBox(height: screenHeight * 0.05),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            width: screenWidth * 0.025,
            height: screenHeight * 0.015,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.009),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index ? Colors.blue : Colors.grey[300],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(screenHeight * 0.015),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.001, vertical: screenHeight * 0.04),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Let's Get to Know You!",
                      style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Text('First name',
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500)),
                  TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Value',
                      hintStyle: TextStyle(color: ColorsManager.grayLow),
                    ),
                    onChanged: (value) => _profile.firstName = value,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text('Last name',
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500)),
                  TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Value',
                      hintStyle: TextStyle(color: ColorsManager.grayLow),
                    ),
                    onChanged: (value) => _profile.lastName = value,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text('Date of Birth',
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500)),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(hintText: 'DD/MM/YYYY'),
                      child: Text(
                        _profile.dateOfBirth == null
                            ? ''
                            : DateFormat('dd/MM/yyyy')
                            .format(_profile.dateOfBirth!),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text('Gender',
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        fillColor:
                        WidgetStatePropertyAll(ColorsManager.primaryColor),
                        value: 'Male',
                        groupValue: _profile.gender,
                        onChanged: (value) =>
                            setState(() => _profile.gender = value!),
                      ),
                      Text('Male',
                          style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: screenWidth * 0.1),
                      Radio<String>(
                        fillColor:
                        WidgetStatePropertyAll(ColorsManager.primaryColor),
                        value: 'Female',
                        groupValue: _profile.gender,
                        onChanged: (value) =>
                            setState(() => _profile.gender = value!),
                      ),
                      Text('Female',
                          style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(screenHeight * 0.015),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.001, vertical: screenHeight * 0.06),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenHeight * 0.015),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Where Are You Located?',
                      style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Text('Wilaya',
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _profile.wilaya,
                        items: wilayas
                            .map((w) => DropdownMenuItem(
                          value: w,
                          child: Text(w,
                              style: TextStyle(color: Colors.black)),
                        ))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _profile.wilaya = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Select Your Wilaya',
                          hintStyle: TextStyle(color: ColorsManager.grayLow),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Text('Commune',
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w500)),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Value',
                          hintStyle: TextStyle(color: ColorsManager.grayLow),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onChanged: (value) => _profile.commune = value,
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Text('Street',
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w500)),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Value',
                          hintStyle: TextStyle(color: ColorsManager.grayLow),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onChanged: (value) => _profile.street = value,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.035),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Your Education & Interests',
              style: TextStyle(
                  fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          Text('Level of Education',
              style: TextStyle(
                  fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
          DropdownButtonFormField<String>(
            value: _profile.educationLevel,
            items: educationLevels
                .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ))
                .toList(),
            onChanged: (value) => setState(() => _profile.educationLevel = value),
            decoration: InputDecoration(
                hintText: 'Select your level',
                hintStyle: TextStyle(color: ColorsManager.grayLow)),
          ),
          SizedBox(height: screenHeight * 0.023),
          Text('Interests',
              style: TextStyle(
                  fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
          Wrap(
            spacing: screenWidth * 0.02,
            children: interests
                .map((interest) => FilterChip(
              label: Text(
                interest,
                style: TextStyle(
                  color: _profile.interests.contains(interest)
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              selected: _profile.interests.contains(interest),
              selectedColor: Colors.blue,
              checkmarkColor: Colors.white,
              backgroundColor: Colors.grey[10],
              onSelected: (selected) => setState(() {
                if (selected) {
                  _profile.interests.add(interest);
                } else {
                  _profile.interests.remove(interest);
                }
              }),
            ))
                .toList(),
          ),
          SizedBox(height: screenHeight * 0.023),
          Text('Other Skills',
              style: TextStyle(
                  fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
          Wrap(
            spacing: screenWidth * 0.02,
            children: skills
                .map((skill) => FilterChip(
              label: Text(
                skill,
                style: TextStyle(
                  color: _profile.skills.contains(skill)
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              selected: _profile.skills.contains(skill),
              selectedColor: Colors.blue,
              checkmarkColor: Colors.white,
              backgroundColor: Colors.grey[10],
              onSelected: (selected) => setState(() {
                if (selected) {
                  _profile.skills.add(skill);
                } else {
                  _profile.skills.remove(skill);
                }
              }),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenHeight * 0.015),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.001),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(screenHeight * 0.015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Download necessary files',
                style: TextStyle(
                    fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text('Profile Picture (optional)',
                style: TextStyle(
                    fontSize: screenWidth * 0.037, fontWeight: FontWeight.w500)),
            SizedBox(height: screenHeight * 0.01),
            Align(
              alignment: Alignment.center,
              child: ProfilePicturePicker(
                imageUrl: _profile.profilePicture,
                onImagePicked: (filePath) {
                  setState(() {
                    _profile.profilePicture = filePath;
                    print('📸 Profile picture selected: $filePath');
                  });
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text('Upload CV (optional)',
                style: TextStyle(
                    fontSize: screenWidth * 0.035, fontWeight: FontWeight.w500)),
            FileUploadWidget(
              filePath: _profile.cv,
              fileType: 'cv',
              onFileSelected: (filePath) {
                setState(() {
                  _profile.cv = filePath;
                  print('📄 CV selected: $filePath');
                });
              },
              onFileRemoved: () => setState(() {
                _profile.cv = null;
                print('🗑️ CV removed');
              }),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text('Upload Certificate/Diploma (optional)',
                style: TextStyle(
                    fontSize: screenWidth * 0.035, fontWeight: FontWeight.w500)),
            FileUploadWidget(
              filePath: _profile.diploma,
              fileType: 'diploma',
              onFileSelected: (filePath) {
                setState(() {
                  _profile.diploma = filePath;
                  print('📜 Diploma selected: $filePath');
                });
              },
              onFileRemoved: () => setState(() {
                _profile.diploma = null;
                print('🗑️ Diploma removed');
              }),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text('Receive Notifications',
                style: TextStyle(
                    fontSize: screenWidth * 0.037, fontWeight: FontWeight.w500)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<bool>(
                  fillColor: WidgetStatePropertyAll(ColorsManager.primaryColor),
                  value: true,
                  groupValue: _profile.receiveNotifications,
                  onChanged: (value) =>
                      setState(() => _profile.receiveNotifications = value!),
                ),
                Text('Yes',
                    style: TextStyle(
                        fontSize: screenWidth * 0.042,
                        fontWeight: FontWeight.w500)),
                SizedBox(width: screenWidth * 0.12),
                Radio<bool>(
                  fillColor: WidgetStatePropertyAll(ColorsManager.primaryColor),
                  value: false,
                  groupValue: _profile.receiveNotifications,
                  onChanged: (value) =>
                      setState(() => _profile.receiveNotifications = value!),
                ),
                Text('No',
                    style: TextStyle(
                        fontSize: screenWidth * 0.042,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: screenWidth * 0.03),
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _goToPreviousPage,
                child: Text(
                  'Previous',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsManager.GEDinkum,
                      fontSize: screenWidth * 0.035,
                      color: ColorsManager.black),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.019),
                ),
              ),
            ),
          SizedBox(width: screenWidth * 0.04),
          if (_currentPage == 0) Spacer(),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentPage == 3 ? _submitForm : _goToNextPage,
              child: Text(
                _currentPage == 3 ? 'Submit' : 'Next',
                style: TextStyle(
                    color: ColorsManager.white,
                    fontSize: screenWidth * 0.041,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsManager.GEDinkum),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.017),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
        ],
      ),
    );
  }

  void _goToNextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentPage++);
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentPage--);
    }
  }

  Future<String?> _uploadFile(String type, String filePath) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://tamkeens.up.railway.app/upload'));
      request.files.add(await http.MultipartFile.fromPath(type, filePath));
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['url'];
      }
      return null;
    } catch (e) {
      print("❌ File upload failed: $e");
      return null;
    }
  }
}