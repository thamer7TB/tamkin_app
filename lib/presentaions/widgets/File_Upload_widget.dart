import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadWidget extends StatefulWidget {
  final String? filePath;
  final String fileType;
  final ValueChanged<String> onFileSelected;
  final VoidCallback onFileRemoved;

  const FileUploadWidget({
    super.key,
    required this.filePath,
    required this.fileType,
    required this.onFileSelected,
    required this.onFileRemoved,
  });

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
     // هل تُطبع النتيجة هنا؟
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'docx'],
    );
    print("resullllllt + $result");

    if (result != null) {
      setState(() => _isUploading = true); // <-- بعد التأكد فقط
      final filePath = result.files.single.path;
      if (filePath != null) {
         widget.onFileSelected(filePath);
      }
    }

    setState(() => _isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.015),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.grey.shade100,
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1.3,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _isUploading
              ? const CircularProgressIndicator()
              : widget.filePath == null
              ? Row(
            children: [
              _buildIconCircle(Icons.upload_rounded, Colors.grey),
              SizedBox(width: screenWidth * 0.04),
              Text(
                "Click to Upload",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
            ],
          )
              : Row(
            children: [
              _buildIconCircle(Icons.check_circle, Colors.green),
              SizedBox(width: screenWidth * 0.04),
              Text(
                widget.filePath!.split('/').last,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.038,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          // زر إغلاق عند وجود ملف
          if (!_isUploading && widget.filePath != null)
            IconButton(
              onPressed: widget.onFileRemoved,
              icon: const Icon(Icons.close, color: Colors.red),
            ),

          // زر اختيار ملف عند عدم وجود ملف
          if (!_isUploading && widget.filePath == null)
            IconButton(
              onPressed: _pickFile,
              icon: const Icon(Icons.arrow_forward_ios, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildIconCircle(IconData icon, Color color) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withOpacity(0.1),
      child: Icon(icon, color: color, size: 22),
    );
  }
}



