
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:tamkin/presentaions/pages/home/Center_2/screens/Account_tab/Change_Password_Screen.dart';
import 'package:tamkin/presentaions/pages/home/Center_2/screens/Account_tab/Edit_Full_Profile_Screen.dart';
import 'package:tamkin/presentaions/pages/home/Center_2/screens/Account_tab/Edit_Profile_Screen.dart';
import 'package:tamkin/presentaions/pages/home/Center_2/screens/Account_tab/Privacy_Policy_Screen.dart';
import 'package:tamkin/services/Center_3/Training_Center_Services.dart';
import 'package:tamkin/services/local_storage_service.dart';
import '../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../core/resorces/Fonts_Manager.dart';
import '../../../../../models/Center_3/Training_Center_Model.dart';
import '../../../Placeholder.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? centerName;
  String? centerId;
  String? logoUrl;
  String? token;
  final _service = TrainingCenterServices();

  @override
  void initState() {
    super.initState();
    _loadCenterData();
  }

  Future<void> _loadCenterData() async {
    final data = await LocalStorageService.getLoginData();
    if (data != null) {
      setState(() {
        centerName = data['lastName'];
        centerId = data['userId']?.toString();
        logoUrl = data['profileImage'];
        token = data['token']?.toString();
        // تعديل مسار الـ logoUrl إذا كان يحتوي على uploads/
        if (logoUrl != null && logoUrl!.isNotEmpty && !logoUrl!.startsWith('http')) {
          final baseUrl = 'https://tamkeens.up.railway.app/';
          final logoPath = 'download/';
          logoUrl = '$baseUrl$logoPath${logoUrl!.replaceFirst('uploads/', '')}';
        }
      });
    }
  }

  Future<Uint8List> _loadNetworkImageWithAuth(String url, String? token) async {
    final response = await http.get(
      Uri.parse(url),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image: ${response.statusCode}');
    }
  }

  Future<void> _changeLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null && centerId != null && token != null) {
      try {
        final center = TrainingCenterModel(
          id: centerId,
          logo: picked.path,
        );
        final success = await _service.updateTrainingCenter(centerId!, token!, center);
        if (success) {
          // تحديث الـ logoUrl بمسار صحيح
          final baseUrl = 'https://tamkeens.up.railway.app/';
          final logoPath = 'download/';
          final newLogoUrl = '$baseUrl$logoPath${picked.path.split('/').last}'; // افتراضي، قد يتطلب تعديلًا بناءً على استجابة الـ API
          await LocalStorageService.updateProfileImage(newLogoUrl);
          setState(() {
            logoUrl = newLogoUrl;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logo updated')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid center ID or token')),
      );
      _navigateToLogin();
    }
  }

  Future<void> _deleteAccount() async {
    if (centerId == null || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid center ID or token')),
      );
      _navigateToLogin();
      return;
    }

    try {
      final success = await _service.deleteTrainingCenter(centerId!, token!);
      if (success) {
        await LocalStorageService.clearLoginData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );
        _navigateToLogin();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
      if (e.toString().contains('Invalid token') || e.toString().contains('مركز التكوين غير موجود')) {
        _navigateToLogin();
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, "LoginWithEmailScreenScreen", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorsManager.UserGrayScaffold,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileCard(context),
            _buildSection(
              context: context,
              title: 'Manage Profile',
              icon: Icons.manage_accounts_outlined,
              items: [
                _buildListItem(
                  context: context,
                  icon: Icons.folder_outlined,
                  title: 'Manage Information & Documents',
                  onTap: () => _navigateToDocuments(context),
                ),
                _buildListItem(
                  context: context,
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile Information',
                  onTap: () => _navigateToEditProfile(context),
                ),
                _buildListItem(
                  context: context,
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () => _navigateToChangePassword(context),
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: 'Help & Support',
              icon: Icons.help_outline_outlined,
              items: [
                _buildListItem(
                  context: context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy & Policy',
                  onTap: () => _navigateToPrivacyPolicy(context),
                ),
                _buildListItem(
                  context: context,
                  icon: Icons.help_center_outlined,
                  title: 'FAQ & Help',
                  onTap: () => _navigateToFAQ(context),
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: 'Account Actions',
              icon: Icons.account_circle_outlined,
              items: [
                _buildListItem(
                  context: context,
                  icon: Icons.delete_forever,
                  title: 'Delete Account',
                  onTap: () => _confirmDeleteAccount(context),
                ),
              ],
            ),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
              right: Radius.circular(10), left: Radius.circular(10))),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: ColorsManager.primaryColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Profile',
        style: TextStyle(
          color: ColorsManager.primaryColor,
          fontWeight: FontWeight.bold,
          fontFamily: FontsManager.GEDinkum,
        ),
      ),
      centerTitle: true,
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.support_agent_outlined,
                color: ColorsManager.primaryColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const FeatureUnavailableScreen(title: 'Support'),
                  ),
                );
              },
            );
          },
        ),
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.settings,
                color: ColorsManager.primaryColor,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "SettingsScreen");
              },
            );
          },
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(
          left: screenWidth * 0.045,
          bottom: screenWidth * 0.04,
          right: screenWidth * 0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorsManager.primaryColor,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: screenWidth * 0.12,
                    backgroundColor: Colors.grey[200],
                    child: ClipOval(
                      child: logoUrl != null && logoUrl!.isNotEmpty
                          ? FutureBuilder<Uint8List>(
                        future: _loadNetworkImageWithAuth(logoUrl!, token),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            print('Failed to load image: $logoUrl, error: ${snapshot.error}');
                            return Image.asset(
                              'assets/images/center_placeholder.png',
                              fit: BoxFit.cover,
                              width: screenWidth * 0.24,
                              height: screenWidth * 0.24,
                            );
                          } else if (snapshot.hasData) {
                            return Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: screenWidth * 0.24,
                              height: screenWidth * 0.24,
                            );
                          }
                          return Image.asset(
                            'assets/images/center_placeholder.png',
                            fit: BoxFit.cover,
                            width: screenWidth * 0.24,
                            height: screenWidth * 0.24,
                          );
                        },
                      )
                          : Image.asset(
                        'assets/images/center_placeholder.png',
                        fit: BoxFit.cover,
                        width: screenWidth * 0.24,
                        height: screenWidth * 0.24,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.1,
                  height: screenHeight * 0.055,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorsManager.primaryColor, width: 1),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: ColorsManager.primaryColor),
                    onPressed: _changeLogo,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.016),
            Text(
              centerName ?? '...',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                fontFamily: FontsManager.GEDinkum,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              'Training Center',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ID: ${centerId ?? "---"}',
                  style: const TextStyle(color: Colors.grey),
                ),
                SizedBox(width: screenWidth * 0.012),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: centerId ?? '---'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  child: Icon(Icons.copy,
                      size: screenWidth * 0.04, color: ColorsManager.primaryColor),
                ),
              ],
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
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.013,
      ),
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
                Icon(
                  icon,
                  size: screenWidth * 0.065,
                  color: ColorsManager.gray,
                ),
                SizedBox(width: screenWidth * 0.04),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsManager.GEDinkum,
                  ),
                ),
              ],
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildListItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.03,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: screenWidth * 0.055,
              color: title == 'Delete Account' ? Colors.red : ColorsManager.primaryColor,
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  color: title == 'Delete Account' ? Colors.red : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => _confirmLogout(context),
      child: Container(
        margin: EdgeInsets.all(screenWidth * 0.04),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenWidth * 0.03,
          ),
          child: Row(
            children: [
              Icon(
                Icons.logout,
                size: screenWidth * 0.06,
                color: Colors.red,
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: screenWidth * 0.042,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
          ),
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: screenWidth * 0.15,
                  color: Colors.orange,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Confirm Logout',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsManager.GEDinkum,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Are you sure you want to log out of your account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                          side: const BorderSide(color: ColorsManager.primaryColor),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: ColorsManager.primaryColor,
                            fontSize: screenWidth * 0.038,
                            fontFamily: FontsManager.GEDinkum,
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                        ),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.038,
                            fontFamily: FontsManager.GEDinkum,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _performLogout(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
          ),
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: screenWidth * 0.15,
                  color: Colors.red,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Confirm Delete Account',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsManager.GEDinkum,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Are you sure you want to delete your account? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                          side: const BorderSide(color: ColorsManager.primaryColor),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: ColorsManager.primaryColor,
                            fontSize: screenWidth * 0.038,
                            fontFamily: FontsManager.GEDinkum,
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.038,
                            fontFamily: FontsManager.GEDinkum,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _deleteAccount();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    LocalStorageService.clearLoginData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
        context, "LoginWithEmailScreenScreen", (route) => false);
  }

  void _navigateToDocuments(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditFullProfileScreen()),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
    );
  }

  void _navigateToFAQ(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => const FeatureUnavailableScreen(title: 'FAQ & Help')),
    );
  }
}