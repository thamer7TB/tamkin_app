import 'package:flutter/material.dart';
import 'package:tamkin/models/Center_3/Training_Center_Model.dart';
import 'package:tamkin/services/Center_3/Training_Center_Services.dart';
import 'package:tamkin/services/local_storage_service.dart';
import '../../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../../models/System_Data.dart';
import '../../../../../widgets/Profile_Picture_Widjet.dart';

class EditFullProfileScreen extends StatefulWidget {
  const EditFullProfileScreen({super.key});

  @override
  State<EditFullProfileScreen> createState() => _EditFullProfileScreenState();
}

class _EditFullProfileScreenState extends State<EditFullProfileScreen> {
  bool _isLoading = true;
  bool _isEditing = false;
  late TrainingCenterModel _center;
  final _service = TrainingCenterServices();
  String? _centerId;
  String? _token;
  final String _baseUrl = 'https://tamkeens.up.railway.app/';
  final String _logoPath = 'download/';

  @override
  void initState() {
    super.initState();
    _center = TrainingCenterModel();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final local = await LocalStorageService.getLoginData();
      print('Local Storage Data: $local');
      if (local == null) {
        throw Exception('No login data found. Please log in again.');
      }

      _centerId = local['userId']?.toString();
      _token = local['token'];

      if (_centerId == null || _centerId!.isEmpty || _token == null || _token!.isEmpty) {
        throw Exception('Invalid center ID or token. Please log in again.');
      }

      print('Fetching center with centerId: $_centerId, token: $_token');
      final center = await _service.fetchTrainingCenter(_centerId!, _token!);
      if (center != null) {
        setState(() {
          _center = center;
          // تعديل مسار الـ logo من uploads/ إلى download/
          if (_center.logo != null && _center.logo!.isNotEmpty && !_center.logo!.startsWith('http')) {
            _center.logo = '$_baseUrl$_logoPath${_center.logo!.replaceFirst('uploads/', '')}';
          }
        });
      } else {
        throw Exception('No center data returned from API');
      }
    } catch (e) {
      print("Error loading profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
      if (e.toString().contains('Invalid token') || e.toString().contains('مركز التكوين غير موجود')) {
        await LocalStorageService.clearLoginData();
        _navigateToLogin();
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _submitChanges() async {
    setState(() => _isLoading = true);
    try {
      if (_centerId == null || _token == null) {
        throw Exception('Invalid center ID or token.');
      }

      final success = await _service.updateTrainingCenter(_centerId!, _token!, _center);
      if (success) {
        await LocalStorageService.updateLoginData({
          'lastName': _center.name,
          'centerName': _center.name,
          'institutionType': _center.institutionType,
          'specializations': _center.specializations,
          'wilaya': _center.wilaya,
          'commune': _center.commune,
          'street': _center.street,
          'website': _center.website,
          'facebook': _center.facebook,
          'instagram': _center.instagram,
          'twitter': _center.twitter,
          'linkedin': _center.linkedin,
          'logoUrl': _center.logo,
          'profileImage': _center.logo,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print("Update failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Update failed: $e")),
      );
      if (e.toString().contains('Invalid token') || e.toString().contains('مركز التكوين غير موجود')) {
        await LocalStorageService.clearLoginData();
        _navigateToLogin();
      }
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: ColorsManager.UserGrayScaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Edit Profile", style: TextStyle(color: ColorsManager.primaryColor)),
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
        iconTheme: const IconThemeData(color: ColorsManager.primaryColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ProfilePicturePicker(
                imageUrl: _center.logo,
                onImagePicked: (filePath) => setState(() => _center.logo = filePath),
                token: _token, // تمرير الـ token
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading logo: $error');
                  return Container(
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildTextField("Institution Name", _center.name, (val) => _center.name = val),
            _buildTextField("Numero Commerce", _center.numeroCommerce, (val) => _center.numeroCommerce = val),
            _buildTextField("Phone", _center.phone, (val) => _center.phone = val),
            _buildTextField("Email", _center.email, (val) => _center.email = val),
            _buildDropdown("Institution Type", institutionTypeList, _center.institutionType, (val) => _center.institutionType = val ?? ''),
            _buildMultiSelect("Specializations", specializationsList, _center.specializations, (val) => _center.specializations = val),
            _buildTextField("Website", _center.website ?? '', (val) => _center.website = val),
            SizedBox(height: screenHeight * 0.03),
            Text("Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045)),
            _buildDropdown("Wilaya", wilayas, _center.wilaya, (val) => _center.wilaya = val ?? ''),
            _buildTextField("Commune", _center.commune, (val) => _center.commune = val),
            _buildTextField("Street", _center.street, (val) => _center.street = val),
            SizedBox(height: screenHeight * 0.03),
            Text("Social Media", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045)),
            _buildTextField("Facebook", _center.facebook ?? '', (val) => _center.facebook = val),
            _buildTextField("Instagram", _center.instagram ?? '', (val) => _center.instagram = val),
            _buildTextField("LinkedIn", _center.linkedin ?? '', (val) => _center.linkedin = val),
            _buildTextField("Twitter", _center.twitter ?? '', (val) => _center.twitter = val),
            SizedBox(height: screenHeight * 0.03),
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

  Widget _buildMultiSelect(String label, List<String> items, List<String> selectedItems, Function(List<String>) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: items.map((item) {
              final isSelected = selectedItems.contains(item);
              return FilterChip(
                label: Text(item),
                selected: isSelected,
                selectedColor: ColorsManager.primaryColor,
                onSelected: _isEditing
                    ? (selected) {
                  setState(() {
                    if (selected) {
                      selectedItems.add(item);
                    } else {
                      selectedItems.remove(item);
                    }
                    onChanged(selectedItems);
                  });
                }
                    : null,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}