
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tamkin/models/User_1/profile_model.dart';
import 'package:tamkin/services/User_1/profile_service.dart';
import 'package:tamkin/services/local_storage_service.dart';

import '../../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../../models/System_Data.dart';
import '../../../../../widgets/File_Upload_widget.dart';
import '../../../../../widgets/Profile_Picture_Widjet.dart';


class EditFullProfileScreen extends StatefulWidget {
  const EditFullProfileScreen({super.key});

  @override
  State<EditFullProfileScreen> createState() => _EditFullProfileScreenState();
}

class _EditFullProfileScreenState extends State<EditFullProfileScreen> {
  bool _isLoading = true;
  bool _isEditing = false;
  late ProfileModel _profile;
  final _service = ProfileService();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final local = await LocalStorageService.getLoginData();
      _profile = ProfileModel(
        firstName: "Thamer",
        lastName: local?['lastName'] ?? "",
        dateOfBirth: DateTime(2000, 1, 1),
        gender: "Male",
        wilaya: "16 - Algiers",
        commune: "Bab Ezzouar",
        street: "Street 123",
        educationLevel: "Bachelor's Degree",
        interests: ["Technology & IT"],
        skills: ["Flutter"],
        profilePicture: local?['profileImage'],
        cv: null,
        diploma: null,
        receiveNotifications: true,
      );
    } catch (e) {
      print("Error loading profile: $e");
    }
    setState(() => _isLoading = false);
  }

  void _submitChanges() async {
    setState(() => _isLoading = true);
    try {
      final result = await _service.submitProfile(_profile);

      if (result != null) {
        // العملية ناجحة
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context); // الرجوع بعد التعديل
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),

        );
      }
    } catch (e) {
      print("Update failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Update failed: $e")),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: ColorsManager.UserGrayScaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Edit Profile", style: TextStyle(color: ColorsManager.primaryColor)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit, color: ColorsManager.primaryColor),
            onPressed: () {
              if (_isEditing) {
                _submitChanges();
              } else {
                setState(() => _isEditing = true);
              }
            },
          )
        ],
        iconTheme: IconThemeData(color: ColorsManager.primaryColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ProfilePicturePicker(
                imageUrl: _profile.profilePicture,
                onImageUploaded: (url) => setState(() => _profile.profilePicture = url),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildTextField("First Name", _profile.firstName, (val) => _profile.firstName = val),
            _buildTextField("Last Name", _profile.lastName, (val) => _profile.lastName = val),
            _buildDatePicker(),
            _buildDropdown("Wilaya", wilayas, _profile.wilaya?? '', (val) => _profile.wilaya = val),
            _buildTextField("Commune", _profile.commune, (val) => _profile.commune = val),
            _buildTextField("Street", _profile.street, (val) => _profile.street = val),
            _buildDropdown("Education", educationLevels, _profile.educationLevel ?? "", (val) => _profile.educationLevel = val),
            // 🌟 Interests
            Text("Interests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045)),
            Wrap(
              spacing: screenWidth * 0.02,
              runSpacing: screenWidth * 0.02,
              children: interests.map((interest) {
                final isSelected = _profile.interests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  selectedColor: ColorsManager.primaryColor,
                  onSelected:_isEditing
                      ? (selected) {
                    setState(() {
                      if (selected) {
                        _profile.interests.add(interest);
                      } else {
                        _profile.interests.remove(interest);
                      }
                    });
                  } : null,
                );
              }).toList(),
            ),
            SizedBox(height: screenHeight * 0.03),

// 🌟 Skills
            Text("Other Skills", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045)),
            Wrap(
              spacing: screenWidth * 0.02,
              runSpacing: screenWidth * 0.02,
              children: skills.map((skill) {
                final isSelected = _profile.skills.contains(skill);
                return FilterChip(
                  label: Text(skill),
                  selected: isSelected,
                  selectedColor: Colors.blueGrey,
                  onSelected:_isEditing
                      ? (selected){
                    setState(() {
                      if (selected) {
                        _profile.skills.add(skill);
                      } else {
                        _profile.skills.remove(skill);
                      }
                    });
                  } : null,
                );
              }).toList(),
            ),
            SizedBox(height: screenHeight * 0.03),

// 🌟 File Uploads
            Text("Upload CV (optional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045)),
            FileUploadWidget(
              filePath: _profile.cv,
              fileType: 'cv',
              onFileSelected: (filePath) async {
                final url = await _service.uploadFile(filePath, 'cv');
                if (url != null) setState(() => _profile.cv = url);
              },
              onFileRemoved: () => setState(() => _profile.cv = null),
            ),
            SizedBox(height: screenHeight * 0.02),

            Text("Upload Diploma (optional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045)),
            FileUploadWidget(
              filePath: _profile.diploma,
              fileType: 'diploma',
              onFileSelected: (filePath) async {
                final url = await _service.uploadFile(filePath, 'diploma');
                if (url != null) setState(() => _profile.diploma = url);
              },
              onFileRemoved: () => setState(() => _profile.diploma = null),
            ),
            SizedBox(height: screenHeight * 0.03),

// 🌟 Notifications
            Text("Receive Notifications", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045)),
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _profile.receiveNotifications,
                  onChanged:  _isEditing ? (val) => setState(() => _profile.receiveNotifications = val!) : null,
                ),
                Text("Yes"),
                SizedBox(width: screenWidth * 0.1),
                Radio<bool>(
                  value: false,
                  groupValue: _profile.receiveNotifications,
                  onChanged:  _isEditing ? (val) => setState(() => _profile.receiveNotifications = val!) : null,
                ),
                Text("No"),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        enabled: _isEditing,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String currentValue, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: _isEditing ? onChanged : null,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: !_isEditing ? null : () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: _profile.dateOfBirth ?? DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() => _profile.dateOfBirth = pickedDate);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            border: OutlineInputBorder(),
          ),
          child: Text(
            _profile.dateOfBirth == null
                ? 'Select Date'
                : DateFormat('dd/MM/yyyy').format(_profile.dateOfBirth!),
          ),
        ),
      ),
    );
  }
}

