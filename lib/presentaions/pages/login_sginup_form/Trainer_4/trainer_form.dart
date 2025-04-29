

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../../core/resorces/Colors_Manager.dart';
import '../../../../core/resorces/Fonts_Manager.dart';
import '../../../../models/System_Data.dart';
import '../../../../models/Trainer_4/Trainer_Model.dart';
import '../../../../services/Trainer_4/Trainer_Services.dart';
import '../../../widgets/File_Upload_widget.dart';
import '../../../widgets/Profile_Picture_Widjet.dart';


class TrainerFormScreen extends StatefulWidget {
  @override
  _TrainerFormScreenState createState() => _TrainerFormScreenState();
}

class _TrainerFormScreenState extends State<TrainerFormScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final TrainerModel _trainer = TrainerModel(
    firstName: '',
    lastName: '',
    professionalTitle: '',
    yearsOfExperience: '',
    expertiseAreas: [],
    gender: 'Male',
    receiveNotifications: true,
  );
  final TrainerServices _service = TrainerServices();

  Future<void> _submitForm() async {
    if (_trainer.firstName.isEmpty ||
        _trainer.lastName.isEmpty ||
        _trainer.professionalTitle.isEmpty ||
        _trainer.yearsOfExperience.isEmpty ||
        _trainer.expertiseAreas.isEmpty) {
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

      final success = await _service.submitTrainerProfile(_trainer);
      Navigator.of(context).pop();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile saved successfully!')),
        );
        Navigator.pushReplacementNamed(context, '/trainer_home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile')),
        );
      }
    } catch (e) {
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
    );
    if (picked != null && picked != _trainer.dateOfBirth) {
      setState(() {
        _trainer.dateOfBirth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Complete Your Profile',
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
                _buildPersonalInfoPage(),
                _buildProfessionalInfoPage(),
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

  Widget _buildPersonalInfoPage() {
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
              "Let's Get to Know You!",
              style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),

          Text('First name', style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
          TextField(
            decoration: InputDecoration(
              hintText: 'Value',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (value) => _trainer.firstName = value,
          ),
          SizedBox(height: screenHeight * 0.02),

          Text('Last name', style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
          TextField(
            decoration: InputDecoration(
              hintText: 'Value',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (value) => _trainer.lastName = value,
          ),
          SizedBox(height: screenHeight * 0.02),

          Text('Date of Birth', style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
          InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: 'DD/MM/YYYY',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(_trainer.dateOfBirth == null
                  ? ''
                  : DateFormat('dd/MM/yyyy').format(_trainer.dateOfBirth!)),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          Text('Gender', style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: 'Male',
                groupValue: _trainer.gender,
                onChanged: (value) => setState(() => _trainer.gender = value!),
              ),
              Text('Male'),
              SizedBox(width: screenWidth * 0.1),
              Radio(
                value: 'Female',
                groupValue: _trainer.gender,
                onChanged: (value) => setState(() => _trainer.gender = value!),
              ),
              Text('Female'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoPage() {
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
              'Professional information',
              style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),

          Text('Professional Title (Dr./Eng./etc.)',
              style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
          DropdownButtonFormField<String>(
            value: _trainer.professionalTitle.isEmpty ? null : _trainer.professionalTitle,
            items: professionalTitlesList.map((title) => DropdownMenuItem(
              value: title,
              child: Text(title),
            )).toList(),
            onChanged: (value) => setState(() => _trainer.professionalTitle = value!),
            decoration: InputDecoration(
              hintText: 'Select your title',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),

          Text('Years of Experience',
              style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
          DropdownButtonFormField<String>(
            value: _trainer.yearsOfExperience.isEmpty ? null : _trainer.yearsOfExperience,
            items: experienceLevels.map((exp) => DropdownMenuItem(
              value: exp,
              child: Text(exp),
            )).toList(),
            onChanged: (value) => setState(() => _trainer.yearsOfExperience = value!),
            decoration: InputDecoration(
              hintText: 'Select one',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),

          Text('Areas of Expertise',
              style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
          InkWell(
            onTap: () => _showExpertiseDialog(),
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: _trainer.expertiseAreas.isEmpty ? 'Select one or more' : '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: _trainer.expertiseAreas.isEmpty
                  ? null
                  : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _trainer.expertiseAreas.map((exp) => Chip(
                  label: Text(exp),
                  backgroundColor: ColorsManager.primaryColor.withOpacity(0.1),
                )).toList(),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),

          Text('LinkedIn (Optional)',
              style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
          TextField(
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'LinkedIn link',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onChanged: (value) => _trainer.linkedin = value,
          ),
        ],
      ),
    );
  }

  Future<void> _showExpertiseDialog() async {
    final List<String>? result = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Select Areas of Expertise"),
        content: SingleChildScrollView(
          child: MultiSelectDialogField(
            items: expertiseAreasList.map((e) => MultiSelectItem(e, e)).toList(),
            initialValue: _trainer.expertiseAreas,
            title: Text("Select"),
            selectedColor: ColorsManager.primaryColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.grey , width: 1),
            ),
            buttonIcon: Icon(Icons.arrow_drop_down),
            buttonText: Text("Select Expertise Areas"),
            onConfirm: (values) {
              Navigator.of(ctx).pop(values);
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(ctx).pop(null),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _trainer.expertiseAreas = result.cast<String>();
      });
    }
  }

  Widget _buildDocumentsPage() {
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
              'Download necessary files',
              style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),

          Text('Profile Picture (optional)',
              style: TextStyle(fontSize: screenWidth * 0.037, fontWeight: FontWeight.w500)),
          SizedBox(height: screenHeight * 0.01),
          Align(
            alignment: Alignment.center,
            child: ProfilePicturePicker(
              imageUrl: _trainer.profilePicture,
              onImageUploaded: (uploadedUrl) {
                setState(() {
                  _trainer.profilePicture = uploadedUrl;
                });
              },
            ),
          ),

          SizedBox(height: screenHeight * 0.03),
          Text('Upload CV',
              style: TextStyle(fontSize: screenWidth * 0.035, fontWeight: FontWeight.w500)),
          FileUploadWidget(
            filePath: _trainer.cv,
            fileType: 'cv',
            onFileSelected: (filePath) async {
              final uploadedUrl = await _service.uploadFile(filePath, 'CV');
              if (uploadedUrl != null) {
                setState(() => _trainer.cv = uploadedUrl);
              }
            },
            onFileRemoved: () => setState(() => _trainer.cv = null),
          ),

          SizedBox(height: screenHeight * 0.03),
          Text('Upload Certificate/Diploma',
              style: TextStyle(fontSize: screenWidth * 0.035, fontWeight: FontWeight.w500)),
          FileUploadWidget(
            filePath: _trainer.diploma,
            fileType: 'diploma',
            onFileSelected: (filePath) async {
              final uploadedUrl = await _service.uploadFile(filePath, 'diploma');
              if (uploadedUrl != null) {
                setState(() => _trainer.diploma = uploadedUrl);
              }
            },
            onFileRemoved: () => setState(() => _trainer.diploma = null),
          ),

          SizedBox(height: screenHeight * 0.03),
          Text('Receive Notifications',
              style: TextStyle(fontSize: screenWidth * 0.037, fontWeight: FontWeight.w500)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: true,
                groupValue: _trainer.receiveNotifications,
                onChanged: (value) => setState(() => _trainer.receiveNotifications = value!),
              ),
              Text('Yes'),
              SizedBox(width: screenWidth * 0.12),
              Radio(
                value: false,
                groupValue: _trainer.receiveNotifications,
                onChanged: (value) => setState(() => _trainer.receiveNotifications = value!),
              ),
              Text('No'),
            ],
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