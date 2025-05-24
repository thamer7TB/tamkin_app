import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../../core/resorces/Fonts_Manager.dart';
import '../../../../../../services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorsManager.UserGrayScaffold,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.045),
        child: Column(
          children: [
            // Language Setting
            _buildSettingItem(
              context,
              icon: Icons.language,
              title: 'Language',
              value: 'English',
              onTap: () => _showLanguageDialog(context),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Dark Mode Toggle
            _buildSettingItem(
              context,
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              isToggle: true,
              toggleValue: _isDarkMode,
              onToggle: (value) {
                setState(() => _isDarkMode = value);
                // TODO: Implement dark mode logic
              },
            ),
            SizedBox(height: screenHeight * 0.02),

            // Delete Account (Red Color)
            _buildDeleteAccountButton(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(15),
          left: Radius.circular(15),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: ColorsManager.white),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: ColorsManager.primaryColor,
      title: Text(
        'Settings',
        style: TextStyle(
          color: Colors.white,
          fontFamily: FontsManager.GEDinkum,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSettingItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? value,
        bool isToggle = false,
        bool toggleValue = false,
        ValueChanged<bool>? onToggle,
        VoidCallback? onTap,
      }) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      elevation: 1.5,
      child: ListTile(
        leading: Icon(icon, color: ColorsManager.primaryColor, size: MediaQuery.of(context).size.width * 0.065,),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: FontsManager.GEDinkum,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
        trailing: isToggle
            ? Switch(
          value: toggleValue,
          onChanged: onToggle,
          activeColor: ColorsManager.primaryColor,
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value ?? '',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: MediaQuery.of(context).size.width * 0.035,
              ),
            ),
            Icon(
              size: MediaQuery.of(context).size.width * 0.07,
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      elevation: 1.5,
      child: ListTile(
        leading: Icon(
          size: MediaQuery.of(context).size.width * 0.065,
          Icons.delete_outline,
          color: Colors.red[400],
        ),
        title: Text(
          'Delete Account',
          style: TextStyle(
            color: Colors.red[400],
            fontFamily: FontsManager.GEDinkum,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.042,
          ),
        ),
        trailing: Icon(
          size: MediaQuery.of(context).size.width * 0.07,
          Icons.chevron_right,
          color: Colors.grey[400],
        ),
        onTap: () => _confirmAccountDeletion(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English', true),
              _buildLanguageOption('العربية', false),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, bool isSelected) {
    return ListTile(
      title: Text(language),
      trailing: isSelected
          ? Icon(Icons.check, color: ColorsManager.primaryColor)
          : null,
      onTap: () {
        // TODO: Implement language change
        Navigator.pop(context);
      },
    );
  }

  Future<void> _confirmAccountDeletion(BuildContext context) async {
    final userData = await LocalStorageService.getLoginData();
    if (userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data not found. Please log in again.')),
      );
      return;
    }

    final token = userData['token'];
    final userId = userData['userId'];

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Are you sure you want to permanently delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(ctx),
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.pop(ctx);
                await _deleteAccount(context, token, userId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context, String? token, String? userId) async {
    if (token == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid token or user ID.')),
      );
      return;
    }

    print('Deleting account with userId: $userId, token: $token');

    try {
      final response = await http.delete(
        Uri.parse('https://tamkeens.up.railway.app/users/$userId'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
      );

      print('Delete Response - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        // حذف البيانات من LocalStorageService
        await LocalStorageService.clearLoginData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account deleted successfully.')),
        );
        // التوجيه إلى صفحة تسجيل الدخول أو الصفحة الرئيسية
        Navigator.pushNamedAndRemoveUntil(context, "LoginWithEmailScreenScreen", (route) => false);
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid token. Please log in again.')),
        );
        // التوجيه إلى صفحة تسجيل الدخول
        Navigator.pushNamedAndRemoveUntil(context, "LoginWithEmailScreenScreen", (route) => false);
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account not found.')),
        );
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error. Please try again later.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account. Please try again.')),
        );
      }
    } catch (e) {
      print('Error deleting account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}