// lib/screens/profile_screen.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tamkin/core/resorces/Colors_Manager.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';
import '../../../../models/System_Data.dart';
import '../../../../models/profile_model.dart';
import '../../../../services/profile_service.dart';
import '../../../widgets/File_Upload_widget.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

    Future<void> _submitForm() async {
    // التحقق من صحة البيانات قبل الإرسال
    if (_profile.firstName.isEmpty || _profile.lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      // عرض مؤشر تحميل
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // إرسال البيانات عبر الخدمة
      final success = await _service.submitProfile(_profile);

      // إغلاق مؤشر التحمل
      Navigator.of(context).pop();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile saved successfully!')),
        );
        // الانتقال إلى الشاشة التالية بعد الحفظ
        Navigator.pushReplacementNamed(context, '/home');
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // لون الهيدر
              onPrimary: Colors.white, // لون النص في الهيدر
              surface: Colors.white, // لون الخلفية
              onSurface: Colors.black, // لون النص
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // لون زر التأكيد
              ),
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

  int _currentPage = 0;
  final PageController _pageController = PageController();
  final ProfileModel _profile = ProfileModel();
  final ProfileService _service = ProfileService();

  // ... (بقية المتغيرات)

  @override
  Widget build(BuildContext context) {
    print('----- بناء الواجهة -----');
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Complete Your Profile' ,style: TextStyle(color: ColorsManager.primaryColor , fontFamily: FontsManager.GEDinkum , fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Column(
        children: [

          // منطقة الفورم
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

          // مؤشر الصفحات
          _buildPageIndicator(),
          // أزرار التنقل
          _buildNavigationButtons(),
          SizedBox(height: screenHeight*0.05),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(vertical:screenHeight*0.01 ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            width: screenWidth*0.025,
            height: screenHeight*0.015,
            margin: EdgeInsets.symmetric(horizontal: screenWidth*0.009),
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
        //SizedBox(height: screenHeight*0.01),
        Container(
          margin: EdgeInsets.all(screenHeight*0.015),
          padding: EdgeInsets.symmetric( horizontal:  screenWidth*0.001 ,vertical: screenHeight*0.04 ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth*0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align (
                    alignment: Alignment.center,
                    child: Text("Let's Get to Know You!",
                        style: TextStyle(fontSize: screenWidth*0.06 , fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: screenHeight*0.05),
                  Text('First name', style: TextStyle( fontSize: screenWidth*0.04,fontWeight: FontWeight.w500)),
                  TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'Value',
                      hintStyle: TextStyle(color: ColorsManager.grayLow),

                    ),
                    onChanged: (value) => _profile.firstName = value,
                  ),
                  SizedBox(height: screenHeight*0.02),

                  Text('Last name', style: TextStyle( fontSize: screenWidth*0.04,fontWeight: FontWeight.w500)),
                  TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      hintText: 'Value',
                      hintStyle: TextStyle(color: ColorsManager.grayLow),
                    ),
                    onChanged: (value) => _profile.lastName = value,
                  ),
                  SizedBox(height: screenHeight*0.02),

                  Text('Date of Birth', style: TextStyle( fontSize: screenWidth*0.04,fontWeight: FontWeight.w500)),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(hintText: 'DD/MM/YYYY'),
                      child: Text(_profile.dateOfBirth == null
                          ? ''
                          : DateFormat('dd/MM/yyyy').format(_profile.dateOfBirth!)),
                    ),
                  ),
                  SizedBox(height: screenHeight*0.02),

                  Text('Gender', style: TextStyle( fontSize: screenWidth*0.04,fontWeight: FontWeight.w500)),
                  SizedBox(height: screenHeight*0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        fillColor: WidgetStatePropertyAll(ColorsManager.primaryColor),
                        value: 'Male',
                        groupValue: _profile.gender,
                        onChanged: (value) => setState(() => _profile.gender = value!),
                      ),
                      Text('Male' ,style: TextStyle(fontSize: screenWidth*0.042,fontWeight: FontWeight.w500 ),),
                      SizedBox(width: screenWidth*0.1),
                      Radio(
                        fillColor: WidgetStatePropertyAll(ColorsManager.primaryColor),
                        value: 'Female',
                        groupValue: _profile.gender,
                        onChanged: (value) => setState(() => _profile.gender = value!),
                      ),
                      Text('Female' ,style: TextStyle(fontSize: screenWidth*0.042,fontWeight: FontWeight.w500 ),),
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
          margin: EdgeInsets.all(screenHeight*0.015),
          padding: EdgeInsets.symmetric( horizontal:  screenWidth*0.001 ,vertical: screenHeight*0.06 ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenHeight*0.015),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align (
                      alignment: Alignment.center,
                      child: Text('Where Are You Located?',
                          style: TextStyle(fontSize: screenWidth*0.06 , fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: screenHeight*0.05),
                    Text('Wilaya', style: TextStyle( fontSize: screenWidth*0.04,fontWeight: FontWeight.w500)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _profile.wilaya,
                      items: wilayas.map((w) => DropdownMenuItem(
                        value: w,
                        child: Text(
                          w.replaceAll(RegExp(""), ''), // إزالة الأرقام من بداية النص
                          style: TextStyle(color: Colors.black),
                        ),
                      )).toList(),
                      onChanged: (String? value) { // تحديد نوع المعامل كـ String?
                        setState(() {
                          _profile.wilaya = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select Your Wilaya',
                        hintStyle: TextStyle(color: ColorsManager.grayLow),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight*0.025),

                    Text('Commune', style: TextStyle( fontSize: screenWidth*0.04,fontWeight: FontWeight.w500)),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Value',
                        hintStyle: TextStyle(color: ColorsManager.grayLow),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                      onChanged: (value) => _profile.commune = value,
                    ),
                    SizedBox(height: screenHeight*0.025),

                    Text('Street', style: TextStyle( fontSize: screenWidth*0.04,fontWeight: FontWeight.w500)),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Value',
                        hintStyle: TextStyle(color: ColorsManager.grayLow),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                      ),
                      onChanged: (value) => _profile.street = value,
                    ),
                  ],
                )
            ])),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth*0.035),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align (
            alignment: Alignment.center,
            child: Text('Your Education & Interests',
                style: TextStyle(fontSize: screenWidth*0.06 , fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: screenHeight*0.05),
          Text('Level of Education', style: TextStyle( fontSize: screenWidth*0.04,fontWeight: FontWeight.w500)),
          DropdownButtonFormField<String>(
            value: _profile.educationLevel,
            items: educationLevels.map((e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            )).toList(),
            onChanged: (value) => setState(() => _profile.educationLevel = value),
            decoration: InputDecoration(hintText: 'Select your level' , hintStyle: TextStyle(color: ColorsManager.grayLow),),
          ),
          SizedBox(height: screenHeight*0.023),

          Text('Interests', style: TextStyle( fontSize: screenWidth*0.04,fontWeight: FontWeight.w500)),

          Wrap(
            spacing: screenWidth*0.02,
            children: interests.map((interest) => FilterChip(
              label: Text(interest , style: TextStyle(
              color: _profile.interests.contains(interest)
                  ? Colors.white // لون النص إذا كان محددًا
                  : Colors.black, // لون النص إذا كان غير محدد
            ),),
              selected: _profile.interests.contains(interest),
              selectedColor: Colors.blue, // لون الخلفية عند التحديد
              checkmarkColor: Colors.white, // لون علامة ✓
              backgroundColor: Colors.grey[50],
              onSelected: (selected) => setState(() {
                print('--- قبل setState ---');
                if (selected) {
                  _profile.interests.add(interest);
                  print('تم الإضافة: $interest - القائمة الآن: ${_profile.interests}');
                } else {
                  _profile.interests.remove(interest);
                  print('تم الإزالة: $interest - القائمة الآن: ${_profile.interests}');
                }
              }),
            )).toList(),
          ),
          SizedBox(height: screenHeight*0.023),

          Text('Other Skills', style: TextStyle( fontSize: screenWidth*0.04,fontWeight: FontWeight.w500)),
          Wrap(
            spacing: screenWidth*0.02,
            children: skills.map((skill) => FilterChip(
              label: Text(skill , style: TextStyle(
                color: _profile.interests.contains(skill)
                    ? Colors.white // لون النص إذا كان محددًا
                    : Colors.black87, // لون النص إذا كان غير محدد
              ),),
              selected: _profile.skills.contains(skill),
              selectedColor: Colors.blue[300], // لون الخلفية عند التحديد
              checkmarkColor: Colors.white, // لون علامة ✓
              backgroundColor: Colors.grey[50],
              onSelected: (selected) => setState(() {
                if (selected) {
                  _profile.skills.add(skill);
                } else {
                  _profile.skills.remove(skill);
                }
              }),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.all(screenHeight*0.015),
      padding: EdgeInsets.symmetric( horizontal:  screenWidth*0.001 ,vertical: screenHeight*0.06 ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(screenHeight*0.015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align (
              alignment: Alignment.center,
              child: Text('Download necessary files',
                  style: TextStyle(fontSize: screenWidth*0.06 , fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: screenHeight*0.02),
            Text('Profile Picture (optional)', style: TextStyle( fontSize: screenWidth*0.04,fontWeight: FontWeight.w500)),
            //SizedBox(height: screenHeight*0.01),
            //_buildFileUpload('profile', _profile.profilePicture),
            FileUploadWidget(
              filePath: _profile.profilePicture,
              fileType: 'profile',
              onFileSelected: (filePath) async {
                final uploadedUrl = await _service.uploadFile(filePath, 'profile');
                if (uploadedUrl != null) {
                  setState(() => _profile.profilePicture = uploadedUrl);
                }
              },
              onFileRemoved: () {
                setState(() => _profile.profilePicture = null);
              },
            ),
            //SizedBox(height: screenHeight*0.03),
            Text('Upload CV (optional)', style: TextStyle( fontSize: screenWidth*0.035,fontWeight: FontWeight.w500)),
            //SizedBox(height: screenHeight*0.01),
            //_buildFileUpload('cv', _profile.cv),
            FileUploadWidget(
              filePath: _profile.cv,
              fileType: 'cv',
              onFileSelected: (filePath) async {
                final uploadedUrl = await _service.uploadFile(filePath, 'CV');
                if (uploadedUrl != null) {
                  setState(() => _profile.cv = uploadedUrl);
                }
              },
              onFileRemoved: () => setState(() => _profile.cv = null),
            ),
           // SizedBox(height: screenHeight*0.03),
            Text('Upload Certificate/Diploma(optional)', style: TextStyle( fontSize: screenWidth*0.035,fontWeight: FontWeight.w500)),
            //SizedBox(height: screenHeight*0.01),
            //_buildFileUpload('diploma', _profile.diploma),
            FileUploadWidget(
              filePath: _profile.diploma,
              fileType: 'diploma',
              onFileSelected: (filePath) async {
                final uploadedUrl = await _service.uploadFile(filePath, 'profile');
                if (uploadedUrl != null) {
                  setState(() => _profile.diploma = uploadedUrl);
                }
              },
              onFileRemoved: () => setState(() => _profile.diploma = null),
            ),

          //  SizedBox(height: screenHeight*0.03),

            Text('Receive Notifications', style: TextStyle( fontSize: screenWidth*0.037,fontWeight: FontWeight.w500)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  fillColor: WidgetStatePropertyAll(ColorsManager.primaryColor),
                  value: true,
                  groupValue: _profile.receiveNotifications,
                  onChanged: (value) => setState(() => _profile.receiveNotifications = value!),
                ),
                Text('Yes' ,style: TextStyle(fontSize: screenWidth*0.042,fontWeight: FontWeight.w500 ),),
                SizedBox(width: screenWidth*0.12),
                Radio(
                  fillColor: WidgetStatePropertyAll(ColorsManager.primaryColor),
                  value: false,
                  groupValue: _profile.receiveNotifications,
                  onChanged: (value) => setState(() => _profile.receiveNotifications = value!),
                ),
                Text('No',style: TextStyle(fontSize: screenWidth*0.042,fontWeight: FontWeight.w500 ),),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildFileUpload(String type, String? currentFile) {
  //   bool _isUploading = false;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       OutlinedButton(
  //         onPressed: _isUploading ? null : () => _uploadFile(type),
  //         child: _isUploading ? CircularProgressIndicator() : Text(currentFile == null ? 'Click to upload' : 'Uploaded: ${currentFile.split('/').last}'),
  //         style: OutlinedButton.styleFrom(
  //           padding: EdgeInsets.symmetric(vertical: 16),
  //         ),
  //       ),
  //       if (currentFile != null)
  //         TextButton(
  //           onPressed: () => _removeFile(type),
  //           child: Text('Remove', style: TextStyle(color: Colors.red)),
  //         ),
  //     ],
  //   );
  // }

  Widget _buildNavigationButtons() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(screenWidth*0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: screenWidth*0.03),
          if (_currentPage > 0)
            Expanded (
              child: OutlinedButton(
                onPressed: _goToPreviousPage,
                child:  Text('Previous', style: TextStyle(fontWeight: FontWeight.bold,  fontFamily:FontsManager.GEDinkum , fontSize: screenWidth * 0.035, color: ColorsManager.black),),
                style :  OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),
                    padding: EdgeInsets.symmetric( vertical: screenHeight*0.019 )
                ),
              ),
            ),
          SizedBox(width: screenWidth*0.04),
          if (_currentPage == 0) Spacer(),
          Expanded (
            child: ElevatedButton(
              onPressed: _currentPage == 3 ? _submitForm : _goToNextPage,
              child: Text(_currentPage == 3 ? 'Submit' : 'Next' , style: TextStyle(color:ColorsManager.white, fontSize: screenWidth * 0.041 ,fontWeight: FontWeight.bold ,  fontFamily:FontsManager.GEDinkum ), ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.primaryColor,
                 shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
               ),
                  padding:  EdgeInsets.symmetric(
                      vertical: screenHeight*0.017 )
            ),
          ),),
          SizedBox(width: screenWidth*0.03),
        ],
      ),
    );
  }

  void _goToNextPage() {
    if (_currentPage < 3) {
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

  Future<void> _uploadFile(String type) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'jpg'],);
    if (result != null) {
      final filePath = result.files.single.path!;
      final url = await _service.uploadFile(filePath, type);
      if (url != null) {
        setState(() {
          if (type == 'profile') _profile.profilePicture = url;
          if (type == 'cv') _profile.cv = url;
          if (type == 'diploma') _profile.diploma = url;
        });
      }
    }
  }

  void _removeFile(String type) {
    setState(() {
      if (type == 'profile') _profile.profilePicture = null;
      if (type == 'cv') _profile.cv = null;
      if (type == 'diploma') _profile.diploma = null;
    });
  }

// ... (بقية الدوال)
}