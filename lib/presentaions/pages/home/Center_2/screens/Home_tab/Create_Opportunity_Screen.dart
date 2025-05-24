import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tamkin/core/resorces/Colors_Manager.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';
import 'package:tamkin/services/Center_3/Training_Center_Services.dart';
import 'package:tamkin/services/local_storage_service.dart';
// لم نعد نستدعي الموديل الكامل هنا
// import '../../../../../../models/User_1/course_opportunity_model.dart';
import '../../../../../../models/Center_3/Create_Opportunity_Request.dart';
import '../../../../../widgets/Custom_Button.dart';

// موديل خاص بإنشاء فرصة
class CreateOpportunityScreen extends StatefulWidget {
  const CreateOpportunityScreen({super.key});

  @override
  State<CreateOpportunityScreen> createState() => _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState extends State<CreateOpportunityScreen> {
  final _service = TrainingCenterServices();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  String? _selectedType;
  String? _selectedMode;
  final _durationController = TextEditingController();
  final _locationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  File? _image;
  bool _isLoading = false;

  final List<String> _categories = ['Technology', 'Business', 'Design'];
  final List<String> _types = ['Workshop', 'Course', 'Seminar'];
  final List<String> _modes = ['Online', 'Offline', 'Hybrid'];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _createOpportunity() async {
    setState(() => _isLoading = true);

    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedType == null ||
        _selectedMode == null ||
        _durationController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _startDateController.text.isEmpty ||
        _endDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select all options.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      final centerData = await LocalStorageService.getLoginData();
      final token = centerData?['token']?.toString();

      final createRequest = CreateOpportunityRequest(
        title: _titleController.text,
        description: _descriptionController.text,
        categoryId: _selectedCategory!,
        type: _selectedType!,
        mode: _selectedMode!,
        duration: _durationController.text,
        location: _locationController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
      );

      // نمرر موديل الإنشاء بدلاً من الموديل الكامل
      final success = await _service.createOpportunity(createRequest, _image, token!);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opportunity created successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create opportunity.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Create New Opportunity',
          style: TextStyle(
            color: ColorsManager.primaryColor,
            fontFamily: FontsManager.GEDinkum,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            ),
            SizedBox(height: screenHeight * 0.02),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
            ),
            SizedBox(height: screenHeight * 0.02),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: _types.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (val) => setState(() => _selectedType = val),
              decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
            ),
            SizedBox(height: screenHeight * 0.02),
            DropdownButtonFormField<String>(
              value: _selectedMode,
              items: _modes.map((mode) => DropdownMenuItem(value: mode, child: Text(mode))).toList(),
              onChanged: (val) => setState(() => _selectedMode = val),
              decoration: const InputDecoration(labelText: 'Mode', border: OutlineInputBorder()),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Duration', border: OutlineInputBorder()),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _startDateController,
              decoration: const InputDecoration(labelText: 'Start Date', border: OutlineInputBorder()),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _endDateController,
              decoration: const InputDecoration(labelText: 'End Date', border: OutlineInputBorder()),
            ),
            SizedBox(height: screenHeight * 0.02),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: screenHeight * 0.15,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorsManager.primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _image == null
                    ? const Center(child: Text('Tap to add image'))
                    : Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: _isLoading ? null : _createOpportunity,
                buttonText: _isLoading ? '' : 'Create Opportunity',
                child: _isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white),
                )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}






