
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/resorces/Colors_Manager.dart';
import '../../services/User_1/profile_service.dart';

class ProfilePicturePicker extends StatefulWidget {
  final String? imageUrl;
  final Function(String) onImageUploaded;

  const ProfilePicturePicker({
    Key? key,
    required this.imageUrl,
    required this.onImageUploaded,
  }) : super(key: key);

  @override
  State<ProfilePicturePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _isUploading = true;
      });

      // ✨ رفع الملف للخادم (هنا نستخدم ملف الخدمة الخاص بك)
      // import الخدمة:
      // import '../../services/profile_service.dart';
      final service = ProfileService();
      final uploadedUrl = await service.uploadFile(picked.path, 'profile');

      if (uploadedUrl != null) {
        widget.onImageUploaded(uploadedUrl);
      }

      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarContent;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (_isUploading) {
      avatarContent = const CircularProgressIndicator();
    } else if (_selectedImage != null) {
      avatarContent = CircleAvatar(
        radius: screenWidth*0.18,
        backgroundImage: FileImage(_selectedImage!),
      );
    } else if (widget.imageUrl != null) {
      avatarContent = CircleAvatar(
        radius: screenWidth*0.18,
        backgroundImage: NetworkImage(widget.imageUrl!),
      );
    } else {
      avatarContent =  CircleAvatar(
        radius: screenWidth*0.18,
        backgroundColor: Colors.grey[400],
        child: Icon(Icons.person, size: screenWidth*0.2, color: Colors.white),
      );
    }

    return GestureDetector(
      onTap: _pickImage,
      child: avatarContent,
    );
  }
}
