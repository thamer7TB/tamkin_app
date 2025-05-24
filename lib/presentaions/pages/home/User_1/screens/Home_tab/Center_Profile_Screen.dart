// CenterProfileScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../../core/resorces/Fonts_Manager.dart';
import '../../../../../../services/User_1/Get_Center_Service.dart';
import '../../../../Placeholder.dart';

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
      print('Social Media Links:');
      print('Facebook: ${data?['facebook']}');
      print('LinkedIn: ${data?['linkedin']}');
      print('X: ${data?['x']}');
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
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileCard(context, location),

            if (_centerData!['description'] != null)
              _buildSection(
                context: context,
                title: 'About Center',
                icon: Icons.info_outline,
                items: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Text(
                      _centerData!['description'],
                      style: TextStyle(fontSize: screenWidth * 0.04, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),

            _buildSection(
              context: context,
              title: 'Contact Information',
              icon: Icons.contact_mail_outlined,
              items: [
                _buildContactItem(context: context, icon: Icons.email_outlined, title: 'Email', value: _centerData!['email']),
                _buildContactItem(context: context, icon: Icons.phone_outlined, title: 'Phone', value: _centerData!['phoneNumber']),
                _buildContactItem(context: context, icon: Icons.language_outlined, title: 'Website', value: _centerData!['website'], isUrl: true),
              ],
            ),

            if (_hasAnySocialMedia())
              _buildSection(
                context: context,
                title: 'Connect with Us',
                icon: Icons.connect_without_contact_outlined,
                items: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: _buildSocialMediaRow(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(10), left: Radius.circular(10)),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: ColorsManager.primaryColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        _centerData!['centerName'] ?? 'Center Profile',
        style: const TextStyle(
          color: ColorsManager.primaryColor,
          fontWeight: FontWeight.bold,
          fontFamily: FontsManager.GEDinkum,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.support_agent_outlined, color: ColorsManager.primaryColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FeatureUnavailableScreen(title: ' Support'),
              ),
            );
          },
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildProfileCard(BuildContext context, String location) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(
        left: screenWidth * 0.045,
        bottom: screenWidth * 0.04,
        right: screenWidth * 0.045,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: screenWidth * 0.01,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: Padding(
        padding:  EdgeInsets.all(screenWidth*0.08),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ColorsManager.primaryColor, width: 3),
              ),
              child: CircleAvatar(
                radius: screenWidth * 0.12,
                backgroundColor: Colors.grey[200],
                child: _centerData!['logoUrl'] != null && _centerData!['logoUrl'].isNotEmpty
                    ? ClipOval(
                  child: Image.network(
                    _centerData!['logoUrl'],
                    fit: BoxFit.cover,
                    width: screenWidth * 0.24,
                    height: screenWidth * 0.24,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Failed to load image: ${_centerData!['logoUrl']}, error: $error');
                      return Image.asset(
                        'assets/images/center_placeholder.png',
                        fit: BoxFit.cover,
                        width: screenWidth * 0.24,
                        height: screenWidth * 0.24,
                      );
                    },
                  ),
                )
                    : Image.asset(
                  'assets/images/center_placeholder.png',
                  fit: BoxFit.cover,
                  width: screenWidth * 0.24,
                  height: screenWidth * 0.24,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.016),
            Text(
              _centerData!['centerName'] ?? '...',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                fontFamily: FontsManager.GEDinkum,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              _centerData!['centerType'] ?? 'Training Center',
              style: const TextStyle(color: Colors.grey),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              location,
              style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.013),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: screenWidth * 0.01,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Row(
              children: [
                Icon(icon, size: screenWidth * 0.065, color: ColorsManager.gray),
                SizedBox(width: screenWidth * 0.04),
                Text(
                  title,
                  style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold, fontFamily: FontsManager.GEDinkum),
                ),
              ],
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? value,
    bool isUrl = false,
  }) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: isUrl ? () => openUrl(value) : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.03),
        child: Row(
          children: [
            Icon(icon, size: screenWidth * 0.055, color: ColorsManager.primaryColor),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Text(
                '$title: $value',
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  color: isUrl ? Colors.blue : Colors.black87,
                  decoration: isUrl ? TextDecoration.underline : null,
                ),
              ),
            ),
            if (isUrl) const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  bool _hasAnySocialMedia() {
    return (_centerData!['facebook'] != null && _isValidUrl(_centerData!['facebook'])) ||
        (_centerData!['linkedin'] != null && _isValidUrl(_centerData!['linkedin'])) ||
        (_centerData!['x'] != null && _isValidUrl(_centerData!['x']));
  }

  Widget _buildSocialMediaRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // رابط تجريبي للتحقق من عمل url_launcher
        //_buildSocialIcon('assets/images/icons/facebook_icon_login.svg', 'https://www.google.com'),
        if (_centerData!['facebook'] != null && _isValidUrl(_centerData!['facebook']))
          _buildSocialIcon('assets/images/icons/facebook_icon_login.svg', _centerData!['facebook']),
        if (_centerData!['linkedin'] != null && _isValidUrl(_centerData!['linkedin']))
          _buildSocialIcon('assets/images/icons/linkedin_icon_login.svg', _centerData!['linkedin']),
        if (_centerData!['x'] != null && _isValidUrl(_centerData!['x']))
          _buildSocialIcon('assets/images/icons/X_icon.svg', _centerData!['x']),
      ],
    );
  }

  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url.startsWith('http') ? url : 'https://$url');
    return uri != null && uri.hasScheme && uri.hasAuthority;
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
    String formattedUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      formattedUrl = 'https://$url';
    }

    print('Attempting to open URL: $formattedUrl');

    final uri = Uri.tryParse(formattedUrl);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      print('Invalid URL: $formattedUrl');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid URL: $url')),
      );
      return;
    }

    try {
      print('Checking if URL can be launched: $formattedUrl');
      if (await canLaunchUrl(uri)) {
        print('Launching URL: $formattedUrl');
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Cannot launch URL: $formattedUrl');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $formattedUrl')),
        );
      }
    } catch (e) {
      print('Error opening URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening link: $e')),
      );
    }
  }
}
