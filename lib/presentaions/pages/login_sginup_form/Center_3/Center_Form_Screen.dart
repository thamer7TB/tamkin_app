import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../../../../core/resorces/Colors_Manager.dart';
import '../../../../core/resorces/Fonts_Manager.dart';
import '../../../../models/Center_3/Training_Center_Model.dart';
import '../../../../models/System_Data.dart';
import '../../../widgets/Profile_Picture_Widjet.dart';
import '../Login_With_Email_screen.dart';

class TrainingCenterFormScreen extends StatefulWidget {
  final String email;
  final String phone;
  final String password;
  final String accreditationNumber;

  const TrainingCenterFormScreen({
    super.key,
    required this.email,
    required this.phone,
    required this.password,
    required this.accreditationNumber,
  });

  @override
  _TrainingCenterFormScreenState createState() => _TrainingCenterFormScreenState();
}

class _TrainingCenterFormScreenState extends State<TrainingCenterFormScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final TrainingCenterModel _center = TrainingCenterModel();
  File? _logoFile;

  @override
  void initState() {
    super.initState();
    _center.email = widget.email;
    _center.phone = widget.phone;
    _center.password = widget.password;
    _center.numeroCommerce = widget.accreditationNumber;
  }

  Future<void> _submitForm() async {
    // التحقق من الحقول المطلوبة
    if (_center.name.isEmpty ||
        _center.email.isEmpty ||
        _center.password.isEmpty ||
        _center.phone.isEmpty ||
        _center.numeroCommerce.isEmpty ||
        _center.institutionType.isEmpty ||
        _center.specializations.isEmpty ||
        _center.wilaya.isEmpty ||
        _center.commune.isEmpty ||
        _center.street.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // عرض مؤشر التحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // إعداد الطلب
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://tamkeens.up.railway.app/signupcenter'),
      );

      // إضافة الحقول
      request.fields['name'] = _center.name;
      request.fields['email'] = _center.email;
      request.fields['password'] = _center.password;
      request.fields['phone'] = _center.phone;
      request.fields['numero_commerce'] = _center.numeroCommerce;
      request.fields['type'] = _center.institutionType;
      request.fields['wilaya'] = _center.wilaya;
      request.fields['Commune'] = _center.commune;
      request.fields['address'] = _center.street;
      request.fields['speciality'] = _center.specializations.join(',');

      // إضافة الحقول الاختيارية
      if (_center.website != null && _center.website!.isNotEmpty) {
        request.fields['website'] = _center.website!;
      }
      if (_center.facebook != null && _center.facebook!.isNotEmpty) {
        request.fields['facebook'] = _center.facebook!;
      }
      request.fields['instagram'] = _center.instagram ?? '';
      if (_center.twitter != null && _center.twitter!.isNotEmpty) {
        request.fields['x'] = _center.twitter!;
      }
      if (_center.linkedin != null && _center.linkedin!.isNotEmpty) {
        request.fields['linkedin'] = _center.linkedin!;
      }
      if (_center.secondPhone != null && _center.secondPhone!.isNotEmpty) {
        request.fields['secondPhone'] = _center.secondPhone!;
      }

      // إضافة ملف الشعار إذا كان موجودًا
      if (_logoFile != null) {
        request.files.add(await http.MultipartFile.fromPath('logo', _logoFile!.path));
        print('📤 Uploading logo: ${_logoFile!.path}');
      }

      // سجل الطلب قبل الإرسال
      print('Sending signupcenter request with fields: ${request.fields}');
      print('Files to upload: ${request.files.length}');

      // إرسال الطلب
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // إغلاق مؤشر التحميل
      Navigator.of(context).pop();

      // سجل الاستجابة
      print('Signupcenter Response - Status: ${response.statusCode}, Body: $responseBody');

      // معالجة الاستجابة
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Center profile created successfully! Please log in to continue.'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  LoginWithEmailScreenScreen()),
              (route) => false,
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bad request: $responseBody')),
        );
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email already exists: $responseBody')),
        );
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: $responseBody')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save center profile: Status ${response.statusCode}, $responseBody')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      print('Error during signupcenter: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true, // تغيير إلى true للسماح بتعديل الحجم عند ظهور لوحة المفاتيح
      appBar: AppBar(
        title: const Text(
          'Training Center Registration',
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
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              children: [
                _buildBasicInfoPage(),
                _buildLocationPage(),
                _buildSocialPage(),
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
        children: List.generate(3, (index) {
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

  Widget _buildBasicInfoPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.035),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              'About Center?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          Text(
            'Institution Name (Required)',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Value',
              hintStyle:  TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (value) => setState(() => _center.name = value),
          ),
          SizedBox(height: screenHeight * 0.025),
          Text(
            'Type (Government/Private/..) (Required)',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          DropdownButtonFormField<String>(
            value: _center.institutionType.isEmpty ? null : _center.institutionType,
            items: institutionTypeList
                .map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            ))
                .toList(),
            onChanged: (value) => setState(() => _center.institutionType = value!),
            decoration: InputDecoration(
              hintText: 'Select Type',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          Text(
            'Specializations (Required)',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          InkWell(
            onTap: () => _showSpecializationsDialog(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputDecorator(
                  decoration: InputDecoration(
                    hintText: _center.specializations.isEmpty
                        ? 'Select'
                        : 'Selected (${_center.specializations.length})',
                    hintStyle: TextStyle(
                      color: _center.specializations.isEmpty
                          ? ColorsManager.grayLow
                          : ColorsManager.primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: ColorsManager.primaryColor,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  child: _center.specializations.isEmpty
                      ? null
                      : Text(
                    _center.specializations.join(', '),
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                Text(
                  'Website (Optional)',
                  style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
                ),
                TextField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'website link',
                    hintStyle:  TextStyle(color: ColorsManager.grayLow),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (value) => setState(() => _center.website = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSpecializationsDialog() async {
    List<String> tempSelected = List.from(_center.specializations);

    final result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Select Specializations"),
              content: SingleChildScrollView(
                child: Column(
                  children: specializationsList.map((item) {
                    return CheckboxListTile(
                      activeColor: ColorsManager.primaryColor,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(item),
                      value: tempSelected.contains(item),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            tempSelected.add(item);
                          } else {
                            tempSelected.remove(item);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(null),
                ),
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop(tempSelected),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _center.specializations = result;
      });
    }
  }

  Widget _buildLocationPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.035),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Center Location',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          Text(
            'Wilaya (Required)',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          DropdownButtonFormField<String>(
            value: _center.wilaya.isEmpty ? null : _center.wilaya,
            items: wilayas
                .map((w) => DropdownMenuItem(
              value: w,
              child: Text(w.replaceAll(RegExp(r"^\d+\s-\s"), '')),
            ))
                .toList(),
            onChanged: (value) => setState(() => _center.wilaya = value!),
            decoration: InputDecoration(
              hintText: 'Select Your Wilaya',
              hintStyle:  TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          Text(
            'Commune (Required)',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Value',
              hintStyle:  TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (value) => setState(() => _center.commune = value),
          ),
          SizedBox(height: screenHeight * 0.025),
          Text(
            'Street (Required)',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Value',
              hintStyle:  TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (value) => setState(() => _center.street = value),
          ),
          SizedBox(height: screenHeight * 0.025),
          Text(
            'Logo (Optional)',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: screenHeight * 0.01),
          Align(
            alignment: Alignment.center,
            child: ProfilePicturePicker(
              imageUrl: _center.logo,
              onImagePicked: (filePath) {
                setState(() {
                  _logoFile = File(filePath);
                  _center.logo = filePath;
                  print('📸 Logo selected: $filePath');
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.035),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Social Media links',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          Text(
            'Facebook (Optional)',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          TextField(
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'facebook link',
              hintStyle:  TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (value) => setState(() => _center.facebook = value),
          ),
          SizedBox(height: screenHeight * 0.025),
          Text(
            'Instagram (Optional)',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          TextField(
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'Instagram link',
              hintStyle:  TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (value) => setState(() => _center.instagram = value),
          ),
          SizedBox(height: screenHeight * 0.025),
          Text(
            'LinkedIn (Optional)',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          TextField(
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'LinkedIn link',
              hintStyle:  TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (value) => setState(() => _center.linkedin = value),
          ),
          SizedBox(height: screenHeight * 0.025),
          Text(
            'X (Optional)',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          TextField(
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'Twitter link',
              hintStyle:  TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (value) => setState(() => _center.twitter = value),
          ),
          SizedBox(height: screenHeight * 0.025),
          Text(
            'Second phone number (Optional)',
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Phone number',
              hintStyle:  TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (value) => setState(() => _center.secondPhone = value),
          ),
        ],
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
          if (_currentPage > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _goToPreviousPage,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.019),
                ),
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsManager.GEDinkum,
                    fontSize: screenWidth * 0.035,
                    color: ColorsManager.black,
                  ),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
          ],
          if (_currentPage == 0) const Spacer(),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentPage == 2 ? _submitForm : _goToNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.017),
              ),
              child: Text(
                _currentPage == 2 ? 'Submit' : 'Next',
                style: TextStyle(
                  color: ColorsManager.white,
                  fontSize: screenWidth * 0.041,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontsManager.GEDinkum,
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
        ],
      ),
    );
  }

  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage--);
    }
  }
}