import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
    double screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_centerData == null) {
      return const Scaffold(
        body: Center(child: Text('❌ Failed to load center profile')),
      );
    }

    final location = "${_centerData!['wilaya'] ?? ''}, ${_centerData!['commune'] ?? ''}, ${_centerData!['street'] ?? ''}";

    return Scaffold(
      backgroundColor: ColorsManager.UserGrayScaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _centerData!['centerName'] ?? "Center Profile",
          style: const TextStyle(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: ColorsManager.primaryColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),

            // Logo
            CircleAvatar(
              radius: screenWidth * 0.18,
              backgroundColor: Colors.grey[200],
              backgroundImage: NetworkImage(_centerData!['logoUrl'] ?? ''),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Name
            Text(
              _centerData!['centerName'] ?? '',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                fontFamily: FontsManager.GEDinkum,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: screenHeight * 0.015),

            // Location
            Text(
              location,
              style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: screenHeight * 0.04),

            // Description
            if (_centerData!['description'] != null)
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  _centerData!['description'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),

            SizedBox(height: screenHeight * 0.04),

            // Contact Info
            _buildContactInfo("📧 Email", _centerData!['email']),
            _buildContactInfo("📞 Phone", _centerData!['phoneNumber']),
            _buildContactInfo("🌐 Website", _centerData!['website'], isUrl: true),

            SizedBox(height: screenHeight * 0.04),

            // Social Media
            if (_hasAnySocialMedia())
              Column(
                children: [
                  Text(
                    "Connect with us",
                    style: TextStyle(
                      fontFamily: FontsManager.GEDinkum,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  _buildSocialMediaRow(),
                ],
              ),
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(String label, String? value, {bool isUrl = false}) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: GestureDetector(
              onTap: isUrl ? () => openUrl(value) : null,
              child: Text(
                value,
                style: TextStyle(
                  color: isUrl ? Colors.blue : Colors.black87,
                  decoration: isUrl ? TextDecoration.underline : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasAnySocialMedia() {
    return _centerData!['facebook'] != null ||
        _centerData!['linkedin'] != null ||
        _centerData!['x'] != null;
  }

  Widget _buildSocialMediaRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_centerData!['facebook'] != null)
          _buildSocialIcon('assets/images/icons/facebook_icon_login.svg', _centerData!['facebook']),
        if (_centerData!['linkedin'] != null)
          _buildSocialIcon('assets/images/icons/linkedin_icon_login.svg', _centerData!['linkedin']),
        if (_centerData!['x'] != null)
          _buildSocialIcon('assets/images/icons/X_icon.svg', _centerData!['x']),
      ],
    );
  }

  Widget _buildSocialIcon(String assetPath, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: IconButton(
        icon: SvgPicture.asset(assetPath, width: 32, height: 32),
        onPressed: () => openUrl(url),
      ),
    );
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Could not open the link")),
      );
    }
  }
}

