import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../core/resorces/Colors_Manager.dart';

class ProfilePicturePicker extends StatefulWidget {
  final String? imageUrl;
  final Function(String) onImagePicked;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final String? token; // جعل token اختياريًا

  const ProfilePicturePicker({
    Key? key,
    required this.imageUrl,
    required this.onImagePicked,
    this.errorBuilder,
    this.token, // إزالة required
  }) : super(key: key);

  @override
  State<ProfilePicturePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;
  File? _selectedImage;
  Uint8List? _networkImageBytes;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    print('Token received: ${widget.token ?? "No token provided"}');
    _loadNetworkImage();
  }

  @override
  void didUpdateWidget(ProfilePicturePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      _loadNetworkImage();
    }
  }

  Future<void> _loadNetworkImage() async {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      setState(() {
        _errorMessage = "No image available";
      });
      return;
    }

    // إذا لم يتم تمرير token، نتخطى محاولة تحميل الصورة من الشبكة
    if (widget.token == null || widget.token!.isEmpty) {
      setState(() {
        _errorMessage = "Authentication token required to load image";
      });
      return;
    }

    try {
      print('Attempting to load image from: ${widget.imageUrl} with token: ${widget.token}');
      final response = await http.get(
        Uri.parse(widget.imageUrl!),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _networkImageBytes = response.bodyBytes;
          _errorMessage = null;
        });
      } else {
        print('❌ Failed to load network image: HTTP ${response.statusCode}, Body: ${response.body}');
        setState(() {
          _errorMessage = 'Failed to load image: HTTP ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      print('❌ Error loading network image: $e');
      setState(() {
        _errorMessage = 'Error loading image: $e';
      });
    }
  }

  Future<void> _pickImage() async {
    setState(() => _isPicking = true);

    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
          _networkImageBytes = null;
          _errorMessage = null;
        });
        widget.onImagePicked(picked.path);
        print("📸 Image selected: ${picked.path}");
      } else {
        print("❌ No image selected.");
      }
    } catch (e) {
      print("❌ Error picking image: $e");
      _showErrorSnackBar("Error picking image: $e");
    }

    setState(() => _isPicking = false);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarContent;

    double screenWidth = MediaQuery.of(context).size.width;

    if (_isPicking) {
      avatarContent = const CircularProgressIndicator();
    } else if (_selectedImage != null) {
      avatarContent = CircleAvatar(
        radius: screenWidth * 0.18,
        backgroundImage: FileImage(_selectedImage!),
      );
    } else if (_networkImageBytes != null) {
      avatarContent = CircleAvatar(
        radius: screenWidth * 0.18,
        backgroundImage: MemoryImage(_networkImageBytes!),
      );
    } else {
      avatarContent = widget.errorBuilder?.call(context, _errorMessage ?? "No image available", null) ??
          CircleAvatar(
            radius: screenWidth * 0.18,
            backgroundColor: Colors.grey[400],
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.person, size: screenWidth * 0.2, color: Colors.white),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.black54,
                    child: Text(
                      _errorMessage != null
                          ? "Error: Tap to try a new image"
                          : "Tap to upload a new image",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
    }

    return GestureDetector(
      onTap: _pickImage,
      child: avatarContent,
    );
  }
}