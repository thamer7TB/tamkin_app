import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/resorces/Colors_Manager.dart';
import '../../../../core/resorces/Fonts_Manager.dart';
import '../../../../models/Center_3/Training_Center_Model.dart';
import '../../../../models/System_Data.dart';
import '../../../../services/Center_3/Training_Center_Services.dart';
import '../../../widgets/Profile_Picture_Widjet.dart';


class TrainingCenterFormScreen extends StatefulWidget {
  @override
  _TrainingCenterFormScreenState createState() => _TrainingCenterFormScreenState();
}

class _TrainingCenterFormScreenState extends State<TrainingCenterFormScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final TrainingCenterModel _center = TrainingCenterModel(
    name: '',
    institutionType: '',
    specializations: [],
    wilaya: '',
    commune: '',
    street: '',
  );
  final TrainingCenterServices _service = TrainingCenterServices();

  Future<void> _submitForm() async {
    if (_center.name.isEmpty ||
        _center.institutionType.isEmpty ||
        _center.specializations.isEmpty ||
        _center.wilaya.isEmpty ||
        _center.commune.isEmpty ||
        _center.street.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete all required fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      final success = await _service.submitCenter(_center);
      Navigator.of(context).pop();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Center profile saved successfully!')),
        );
        Navigator.pushReplacementNamed(context, '/center_home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save center profile')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Training Center Registration',
          style: TextStyle(
              color: ColorsManager.primaryColor,
              fontFamily: FontsManager.GEDinkum,
              fontWeight: FontWeight.bold
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
        Align(
        alignment: Alignment.center,
        child: Text(
          'About Center?',
          style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      SizedBox(height: screenHeight * 0.05),

      // Institution Name
      Text('Institution Name (Required)',
        style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w500
        ),
      ),
      TextField(
        decoration: InputDecoration(
          hintText: 'Value',
          hintStyle: TextStyle(color: ColorsManager.grayLow),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15)
          ),
        ),
        onChanged: (value) => setState(() => _center.name = value),
      ),
      SizedBox(height: screenHeight * 0.025),

      // Institution Type
      Text('Type (Government/Private/..)',
        style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w500
        ),
      ),
      DropdownButtonFormField<String>(
        value: _center.institutionType.isEmpty ? null : _center.institutionType,
        items: institutionTypeList.map((type) => DropdownMenuItem(
          value: type,
          child: Text(type),
        )).toList(),
        onChanged: (value) => setState(() => _center.institutionType = value!),
        decoration: InputDecoration(
          hintText: 'Select Type',
          hintStyle: TextStyle(color: ColorsManager.grayLow),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15)
          ),
        ),
      ),
      SizedBox(height: screenHeight * 0.025),

      // Specializations
      Text('Specializations',
        style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w500
        ),
      ),
      // InkWell(
      //   onTap: () => _showSpecializationsDialog(),
      //   child: InputDecorator(
      //     decoration: InputDecoration(
      //       hintText: _center.specializations.isEmpty
      //           ? 'Select'
      //           : _center.specializations.join(', '),
      //       border: OutlineInputBorder(
      //           borderRadius: BorderRadius.circular(15)
      //       ),
      //     ),
      //   ),
      //   SizedBox(height: screenHeight * 0.025),
      //
      //   // Website (Optional)
      //   Text('Website (Optional)',
      //     style: TextStyle(
      //         fontSize: screenWidth * 0.04,
      //         fontWeight: FontWeight.w500
      //     ),
      //   ),
      //   TextField(
      //     keyboardType: TextInputType.url,
      //     decoration: InputDecoration(
      //       hintText: 'website link',
      //       hintStyle: TextStyle(color: ColorsManager.grayLow),
      //       border: OutlineInputBorder(
      //           borderRadius: BorderRadius.circular(15)
      //       ),
      //     ),
      //     onChanged: (value) => setState(() => _center.website = value),
      //   ),
      // )
          InkWell(
            onTap: () => _showSpecializationsDialog(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputDecorator(
                  decoration: InputDecoration(
                    hintText: _center.specializations.isEmpty ? 'Select' : 'Selected (${_center.specializations.length})',
                    hintStyle: TextStyle(
                      color: _center.specializations.isEmpty
                          ? ColorsManager.grayLow
                          : ColorsManager.primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: ColorsManager.primaryColor,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  child: _center.specializations.isEmpty
                      ? null
                      : Text(
                    _center.specializations.join(', '),
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                // Website (Optional)
                Text(
                  'Website (Optional)',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'website link',
                    hintStyle: TextStyle(color: ColorsManager.grayLow),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (value) => setState(() => _center.website = value),
                ),
              ],
            ),
          ),
        ],),
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
              title: Text("Select Specializations"),
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
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(null),
                ),
                TextButton(
                  child: Text("OK"),
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
          Align(
            alignment: Alignment.center,
            child: Text(
              'Center Location',
              style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),

          // Wilaya
          Text('Wilaya',
            style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500
            ),
          ),
          DropdownButtonFormField<String>(
            value: _center.wilaya.isEmpty ? null : _center.wilaya,
            items: wilayas.map((w) => DropdownMenuItem(
              value: w,
              child: Text(w.replaceAll(RegExp(r"^\d+\s-\s"), '')),
            )).toList(),
            onChanged: (value) => setState(() => _center.wilaya = value!),
            decoration: InputDecoration(
              hintText: 'Select Your Wilaya',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),

          // Commune
          Text('Commune',
            style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Value',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
            onChanged: (value) => setState(() => _center.commune = value),
          ),
          SizedBox(height: screenHeight * 0.025),

          // Street
          Text('Street',
            style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Value',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
            onChanged: (value) => setState(() => _center.street = value),
          ),
          SizedBox(height: screenHeight * 0.025),

          // Logo (Optional)
          Text('Logo (Optional)',
            style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Align(
            alignment: Alignment.center,
            child: ProfilePicturePicker(
              imageUrl: _center.logo,
              onImageUploaded: (uploadedUrl) {
                setState(() {
                  _center.logo = uploadedUrl;
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
          Align(
            alignment: Alignment.center,
            child: Text(
              'Social Media links',
              style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),

          // Facebook (Optional)
          Text('Facebook (Optional)',
            style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500
            ),
          ),
          TextField(
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'facebook link',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
            onChanged: (value) => setState(() => _center.facebook = value),
          ),
          SizedBox(height: screenHeight * 0.025),

          // LinkedIn (Optional)
          Text('LinkedIn (Optional)',
            style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500
            ),
          ),
          TextField(
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'LinkedIn link',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
            onChanged: (value) => setState(() => _center.linkedin = value),
          ),
          SizedBox(height: screenHeight * 0.025),

          // Twitter (Optional)
          Text('X (Optional)',
            style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500
            ),
          ),
          TextField(
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'Twitter link',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
            onChanged: (value) => setState(() => _center.twitter = value),
          ),
          SizedBox(height: screenHeight * 0.025),

          // Second phone (Optional)
          Text('Second phone number (Optional)',
            style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500
            ),
          ),
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Phone number',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
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
                child: Text(
                  'Previous',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsManager.GEDinkum,
                      fontSize: screenWidth * 0.035,
                      color: ColorsManager.black
                  ),
                ),
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.019)
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
          ],
          if (_currentPage == 0) Spacer(),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentPage == 2 ? _submitForm : _goToNextPage,
              child: Text(
                _currentPage == 2 ? 'Submit' : 'Next',
                style: TextStyle(
                    color: ColorsManager.white,
                    fontSize: screenWidth * 0.041,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsManager.GEDinkum
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.017)
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
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage--);
    }
  }
}