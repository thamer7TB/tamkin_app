import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tamkin/models/User_1/profile_model.dart';
import 'package:tamkin/services/User_1/profile_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../../models/System_Data.dart';
import '../../../../../widgets/File_Upload_widget.dart';
import '../../../../../widgets/Profile_Picture_Widjet.dart';

class EditFullProfileScreen extends StatefulWidget {
  final String userId;
  final String token;

  const EditFullProfileScreen({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  State<EditFullProfileScreen> createState() => _EditFullProfileScreenState();
}

class _EditFullProfileScreenState extends State<EditFullProfileScreen> {
  bool _isLoading = true;
  bool _isEditing = false;
  late ProfileModel _profile;
  final _service = ProfileService();
  final List<String> _genders = ['Male', 'Female'];
  final String _baseUrl = 'https://tamkeens.up.railway.app/';
  final String _profilePicturePath = 'download/';
  final String _filePath = 'uploads/';

  @override
  void initState() {
    super.initState();
    _profile = ProfileModel(
      firstName: '',
      lastName: '',
      dateOfBirth: DateTime.now(),
      gender: 'Male',
      wilaya: '',
      commune: '',
      street: '',
      educationLevel: '',
      interests: [],
      skills: [],
      profilePicture: '',
      cv: null,
      diploma: null,
      receiveNotifications: true,
    );
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      if (widget.userId.isEmpty || widget.token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid user ID or token. Please log in again.')),
        );
        _navigateToLogin();
        return;
      }

      print('Loading profile with userId: ${widget.userId}, token: ${widget.token}');

      final response = await http.get(
        Uri.parse('https://tamkeens.up.railway.app/users/${widget.userId}'),
        headers: {
          'Authorization': '${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      print('Get Profile Response - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> interestsList = [];
        if (data['interests'] != null && data['interests'].toString().isNotEmpty) {
          interestsList = data['interests'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        }

        List<String> skillsList = [];
        if (data['skills'] != null && data['skills'].toString().isNotEmpty) {
          skillsList = data['skills'].toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        }

        setState(() {
          _profile = ProfileModel(
            firstName: data['first_name']?.toString() ?? '',
            lastName: data['last_name']?.toString() ?? '',
            dateOfBirth: data['date_of_birth'] != null
                ? DateTime.parse(data['date_of_birth'])
                : DateTime(2000, 1, 1),
            gender: data['gender']?.toString() ?? 'Male',
            wilaya: data['wilaya']?.toString() ?? '16 - Algiers',
            commune: data['commune']?.toString() ?? '',
            street: data['street']?.toString() ?? '',
            educationLevel: data['level_of_education']?.toString() ?? '',
            interests: interestsList,
            skills: skillsList,
            profilePicture: data['profile_picture'] != null
                ? '$_baseUrl$_profilePicturePath${data['profile_picture'].replaceFirst('uploads/', '')}'
                : '',
            cv: data['cv'] != null ? '$_baseUrl$_filePath${data['cv'].replaceFirst('uploads/', '')}' : null,
            diploma: data['certificate'] != null ? '$_baseUrl$_filePath${data['certificate'].replaceFirst('uploads/', '')}' : null,
            receiveNotifications: data['receive_notifications'] ?? true,
          );
        });
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid token. Please log in again.')),
        );
        _navigateToLogin();
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found. Please log in again.')),
        );
        _navigateToLogin();
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error. Please try again later.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile. Please try again.')),
        );
      }
    } catch (e) {
      print("Error loading profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _submitChanges() async {
    setState(() => _isLoading = true);
    try {
      if (widget.userId.isEmpty || widget.token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid user ID or token.')),
        );
        _navigateToLogin();
        return;
      }

      print('Submitting changes with userId: ${widget.userId}, token: ${widget.token}');

      var request = http.MultipartRequest('PUT', Uri.parse('https://tamkeens.up.railway.app/users/${widget.userId}'));
      request.headers.addAll({
        'Authorization': '${widget.token}',
      });

      final Map<String, String> profileData = {
        'first_name': _profile.firstName ?? '',
        'last_name': _profile.lastName ?? '',
        'date_of_birth': _profile.dateOfBirth?.toIso8601String() ?? '',
        'gender': _profile.gender ?? 'Male',
        'wilaya': _profile.wilaya ?? '',
        'commune': _profile.commune ?? '',
        'street': _profile.street ?? '',
        'level_of_education': _profile.educationLevel ?? '',
        'interests': _profile.interests.isNotEmpty ? _profile.interests.join(',') : '',
        'skills': _profile.skills.isNotEmpty ? _profile.skills.join(',') : '',
        'receive_notifications': (_profile.receiveNotifications ?? true).toString(),
      };
      request.fields.addAll(profileData);

      if (_profile.profilePicture != null && _profile.profilePicture!.isNotEmpty && !_profile.profilePicture!.startsWith(_baseUrl)) {
        request.files.add(await http.MultipartFile.fromPath('profile_picture', _profile.profilePicture!));
        print('📤 Added updated profile picture: ${_profile.profilePicture}');
      }
      if (_profile.cv != null && _profile.cv!.isNotEmpty && !_profile.cv!.startsWith(_baseUrl)) {
        request.files.add(await http.MultipartFile.fromPath('cv', _profile.cv!));
        print('📤 Added updated CV: ${_profile.cv}');
      }
      if (_profile.diploma != null && _profile.diploma!.isNotEmpty && !_profile.diploma!.startsWith(_baseUrl)) {
        request.files.add(await http.MultipartFile.fromPath('certificate', _profile.diploma!));
        print('📤 Added updated diploma: ${_profile.diploma}');
      }

      print('Sending PUT request with fields: ${request.fields}, files: ${request.files.length}');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Update Profile Response - Status: ${response.statusCode}, Body: $responseBody');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid token. Please log in again.')),
        );
        _navigateToLogin();
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found. Please log in again to refresh your session.')),
        );
        _navigateToLogin();
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error. Please try again later. Details: $responseBody')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile. Status: ${response.statusCode}, Details: $responseBody')),
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

  void _navigateToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
                onImagePicked: (filePath) => setState(() => _profile.profilePicture = filePath),
                token: widget.token,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading profile picture: $error');
                  return Container(
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildTextField("First Name", _profile.firstName, (val) => _profile.firstName = val),
            _buildTextField("Last Name", _profile.lastName, (val) => _profile.lastName = val),
            _buildDropdown("Gender", _genders, _profile.gender ?? 'Male', (val) => _profile.gender = val ?? 'Male'),
            _buildDatePicker(),
            _buildDropdown("Wilaya", wilayas, _profile.wilaya ?? '', (val) => _profile.wilaya = val),
            _buildTextField("Commune", _profile.commune, (val) => _profile.commune = val),
            _buildTextField("Street", _profile.street, (val) => _profile.street = val),
            _buildDropdown("Education", educationLevels, _profile.educationLevel ?? "", (val) => _profile.educationLevel = val),
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
                  onSelected: _isEditing
                      ? (selected) {
                    setState(() {
                      if (selected && !_profile.interests.contains(interest)) {
                        _profile.interests.add(interest);
                      } else if (!selected && _profile.interests.contains(interest)) {
                        _profile.interests.remove(interest);
                      }
                    });
                  }
                      : null,
                );
              }).toList(),
            ),
            SizedBox(height: screenHeight * 0.03),
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
                  onSelected: _isEditing
                      ? (selected) {
                    setState(() {
                      if (selected && !_profile.skills.contains(skill)) {
                        _profile.skills.add(skill);
                      } else if (!selected && _profile.skills.contains(skill)) {
                        _profile.skills.remove(skill);
                      }
                    });
                  }
                      : null,
                );
              }).toList(),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text("Upload CV (optional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045)),
            FileUploadWidget(
              filePath: _profile.cv,
              fileType: 'cv',
              onFileSelected: (filePath) => setState(() => _profile.cv = filePath),
              onFileRemoved: () => setState(() => _profile.cv = null),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text("Upload Diploma (optional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045)),
            FileUploadWidget(
              filePath: _profile.diploma,
              fileType: 'diploma',
              onFileSelected: (filePath) => setState(() => _profile.diploma = filePath),
              onFileRemoved: () => setState(() => _profile.diploma = null),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text("Receive Notifications", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045)),
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _profile.receiveNotifications,
                  onChanged: _isEditing ? (val) => setState(() => _profile.receiveNotifications = val!) : null,
                ),
                Text("Yes"),
                SizedBox(width: screenWidth * 0.1),
                Radio<bool>(
                  value: false,
                  groupValue: _profile.receiveNotifications,
                  onChanged: _isEditing ? (val) => setState(() => _profile.receiveNotifications = val!) : null,
                ),
                Text("No"),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
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
        value: items.contains(currentValue) ? currentValue : items.first,
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
        onTap: !_isEditing
            ? null
            : () async {
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