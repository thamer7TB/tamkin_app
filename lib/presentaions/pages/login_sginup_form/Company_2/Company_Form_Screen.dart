import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tamkin/core/resorces/Colors_Manager.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';
import '../../../../models/Company_2/company_model.dart';
import '../../../../models/System_Data.dart';
import '../../../../services/Company_2/company_service.dart';
import '../../../widgets/File_Upload_widget.dart';
import '../../../widgets/Profile_Picture_Widjet.dart';

class CompanyProfileScreen extends StatefulWidget {
  @override
  _CompanyProfileScreenState createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final CompanyModel _company = CompanyModel(
    companyName: '',
    industry: '',
    companySize: '',
    wilaya: '',
    commune: '',
    street: '',
  );
  final CompanyServices _service = CompanyServices();

  Future<void> _submitForm() async {
    if (_company.companyName.isEmpty ||
        _company.industry.isEmpty ||
        _company.companySize.isEmpty ||
        _company.wilaya.isEmpty ||
        _company.commune.isEmpty ||
        _company.street.isEmpty) {
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

      final success = await _service.submitCompanyProfile(_company);
      Navigator.of(context).pop();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Company profile saved successfully!')),
        );
        Navigator.pushReplacementNamed(context, '/company_home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save company profile')),
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
        title: Text('Company Profile',
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
                _buildCompanyInfoPage(),
                _buildLocationPage(),
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
        children: List.generate(2, (index) {
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

  Widget _buildCompanyInfoPage() {
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
              'About your Company',
              style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),

          // Company Name
          Text('Company Name (Required)',
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
            onChanged: (value) => setState(() => _company.companyName = value),
          ),
          SizedBox(height: screenHeight * 0.025),

          // Industry
          Text('Industry (Required)',
            style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500
            ),
          ),
          DropdownButtonFormField<String>(
            value: _company.industry.isEmpty ? null : _company.industry,
            items: industryList.map((industry) => DropdownMenuItem(
              value: industry,
              child: Text(industry),
            )).toList(),
            onChanged: (value) => setState(() => _company.industry = value!),
            decoration: InputDecoration(
              hintText: 'Select Your Industry',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),

          // Company Size
          Text('Company Size (Required)',
            style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500
            ),
          ),
          DropdownButtonFormField<String>(
            value: _company.companySize.isEmpty ? null : _company.companySize,
            items: companySizeList.map((size) => DropdownMenuItem(
              value: size,
              child: Text(size),
            )).toList(),
            onChanged: (value) => setState(() => _company.companySize = value!),
            decoration: InputDecoration(
              hintText: 'Select',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),

          // Website (Optional)
          Text('Website (Optional)',
            style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500
            ),
          ),
          TextField(
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'website link',
              hintStyle: TextStyle(color: ColorsManager.grayLow),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
            onChanged: (value) => setState(() => _company.website = value),
          ),
        ],
      ),
    );
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
              'Company Location',
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
            value: _company.wilaya.isEmpty ? null : _company.wilaya,
            items: wilayas.map((w) => DropdownMenuItem(
              value: w,
              child: Text(w.replaceAll(RegExp(r"^\d+\s-\s"), '')),
            )).toList(),
            onChanged: (value) => setState(() => _company.wilaya = value!),
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
            onChanged: (value) => setState(() => _company.commune = value),
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
            onChanged: (value) => setState(() => _company.street = value),
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
              imageUrl: _company.logo,
              onImagePicked: (filePath) {
                setState(() {
                  _company.logo = filePath;
                  print('📸 Logo selected: $filePath');
                });
              },
            ),
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
              onPressed: _currentPage == 1 ? _submitForm : _goToNextPage,
              child: Text(
                _currentPage == 1 ? 'Submit' : 'Next',
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
    if (_currentPage < 1) {
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


