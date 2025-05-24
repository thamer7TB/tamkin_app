import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileUploadWidget extends StatefulWidget {
  final String? filePath;
  final String fileType;
  final Function(String) onFileSelected;
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
  bool _isPicking = false;
  bool _isDownloading = false;
  String? _localFilePath;

  Future<void> _pickFile() async {
    setState(() => _isPicking = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'docx'],
      );
      print("📄 File picker result: $result");

      if (result != null) {
        final filePath = result.files.single.path;
        if (filePath != null) {
          widget.onFileSelected(filePath);
          print("✅ File selected: $filePath");
        } else {
          _showErrorSnackBar("Failed to get file path.");
        }
      } else {
        print("❌ No file selected.");
      }
    } catch (e) {
      print("❌ Error picking file: $e");
      _showErrorSnackBar("Error picking file: $e");
    }

    setState(() => _isPicking = false);
  }

  Future<void> _downloadFile(String url, String fileName) async {
    setState(() => _isDownloading = true);
    try {
      Directory? dir;
      try {
        dir = await getApplicationDocumentsDirectory();
      } catch (e) {
        print("❌ Failed to get documents directory: $e");
        dir = await getExternalStorageDirectory() ?? await getTemporaryDirectory();
      }
      final savePath = '${dir.path}/$fileName';
      await Dio().download(url, savePath);
      setState(() => _localFilePath = savePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File downloaded to $savePath')),
      );
    } catch (e) {
      print("❌ Error downloading file: $e");
      _showErrorSnackBar("Error downloading file: $e");
    }
    setState(() => _isDownloading = false);
  }

  Future<void> _viewFile(String? filePath) async {
    if (filePath == null) return;

    final isImage = filePath.endsWith('.jpg') || filePath.endsWith('.png');
    final isPdf = filePath.endsWith('.pdf');

    if (isImage) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewerScreen(imageUrl: filePath),
        ),
      );
    } else if (isPdf) {
      try {
        String localPath = filePath;
        if (filePath.startsWith('http')) {
          final dir = await getApplicationDocumentsDirectory();
          final savePath = '${dir.path}/temp.pdf';
          await Dio().download(filePath, savePath);
          localPath = savePath;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerScreen(pdfPath: localPath),
          ),
        );
      } catch (e) {
        print("❌ Error viewing PDF: $e");
        _showErrorSnackBar("Error viewing PDF: $e");
      }
    } else {
      _showErrorSnackBar("Unsupported file format for viewing.");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _truncateFileName(String fileName, int maxLength) {
    if (fileName.length <= maxLength) return fileName;
    return '${fileName.substring(0, maxLength - 3)}...';
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _isPicking
                  ? const CircularProgressIndicator()
                  : widget.filePath == null
                  ? Row(
                mainAxisSize: MainAxisSize.min,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIconCircle(Icons.check_circle, Colors.green),
                  SizedBox(width: screenWidth * 0.04),
                  Flexible(
                    child: Text(
                      _truncateFileName(widget.filePath!.split('/').last, 20),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.038,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (!_isPicking && widget.filePath != null)
                    IconButton(
                      onPressed: widget.onFileRemoved,
                      icon: const Icon(Icons.close, color: Colors.red),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  if (!_isPicking && widget.filePath == null)
                    IconButton(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.arrow_forward_ios, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ],
          ),
          if (widget.filePath != null)
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _viewFile(widget.filePath),
                    icon: Icon(Icons.visibility, size: 18),
                    label: Text("View File"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(screenWidth * 0.3, screenHeight * 0.05),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  ElevatedButton.icon(
                    onPressed: _isDownloading
                        ? null
                        : () => _downloadFile(widget.filePath!, widget.filePath!.split('/').last),
                    icon: _isDownloading
                        ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : Icon(Icons.download, size: 18),
                    label: Text("Download"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(screenWidth * 0.3, screenHeight * 0.05),
                    ),
                  ),
                ],
              ),
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

class PdfViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PdfViewerScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View PDF"),
      ),
      body: Center(
        child: PDFView(
          filePath: pdfPath,
          autoSpacing: true,
          enableSwipe: true,
          onError: (error) {
            print("PDF Error: $error");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading PDF: $error')),
            );
          },
          onRender: (pages) {
            print("PDF rendered with $pages pages");
          },
        ),
      ),
    );
  }
}

class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;

  const ImageViewerScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Image"),
      ),
      body: Center(
        child: imageUrl.startsWith('http')
            ? Image.network(imageUrl, fit: BoxFit.contain)
            : Image.file(File(imageUrl), fit: BoxFit.contain),
      ),
    );
  }
}


