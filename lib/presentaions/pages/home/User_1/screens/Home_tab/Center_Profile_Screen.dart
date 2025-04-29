

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../../core/resorces/Fonts_Manager.dart';
import '../../../../../../services/User_1/Get_center_Profile_service.dart';


class CenterProfileScreen extends StatefulWidget {
  final String centerId;

  const CenterProfileScreen({super.key, required this.centerId});

  @override
  State<CenterProfileScreen> createState() => _CenterProfileScreenState();
}

class _CenterProfileScreenState extends State<CenterProfileScreen> {
  Map<String, dynamic>? _centerData;
  bool _isLoading = true;

  final CenterService _centerService = CenterService();

  @override
  void initState() {
    super.initState();
    _fetchCenterData();
  }

  Future<void> _fetchCenterData() async {
    final data = await _centerService.fetchCenterProfile(widget.centerId);
    if (mounted) {
      setState(() {
        _centerData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_centerData == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load center profile')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _centerData!['centerName'] ?? "Center Profile",
          style: TextStyle(
            color: ColorsManager.primaryColor,
            fontFamily: FontsManager.GEDinkum,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: ColorsManager.primaryColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // الشعار
            CircleAvatar(
              radius: screenWidth * 0.18,
              backgroundImage: NetworkImage(_centerData!['logoUrl'] ?? 'https://via.placeholder.com/150'),
            ),
            SizedBox(height: screenWidth * 0.05),

            // اسم المركز
            Text(
              _centerData!['centerName'] ?? 'Center Name',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                fontFamily: FontsManager.GEDinkum,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),

            // الموقع
            Text(
              _centerData!['location'] ?? 'Location not available',
              style: const TextStyle(color: Colors.grey),
            ),
            SizedBox(height: screenWidth * 0.04),

            // وصف المركز
            if (_centerData!['description'] != null)
              Text(
                _centerData!['description'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
            SizedBox(height: screenWidth * 0.05),

            // حسابات التواصل
            _buildSocialMediaRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaRow() {
    final String? facebook = _centerData!['facebook'];
    final String? linkedIn = _centerData!['linkedin'];
    final String? xTwitter = _centerData!['x'];

    if (facebook == null && linkedIn == null && xTwitter == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (facebook != null)
          _buildSocialIcon('assets/images/icons/facebook_icon_login.svg', facebook),
        if (linkedIn != null)
          _buildSocialIcon('assets/images/icons/linkedin_icon_login.svg', linkedIn),
        if (xTwitter != null)
          _buildSocialIcon('assets/images/icons/x_icon.svg', xTwitter),
      ],
    );
  }

  Widget _buildSocialIcon(String assetPath, String url) {
    return IconButton(
      icon: SvgPicture.asset(
        assetPath,
        width: 32,
        height: 32,
      ),
      onPressed: () {
        // فتح الرابط في متصفح خارجي مثلاً لاحقاً
      },
    );
  }
}
