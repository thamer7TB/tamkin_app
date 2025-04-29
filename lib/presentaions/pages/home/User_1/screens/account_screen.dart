import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tamkin/presentaions/pages/home/User_1/screens/Account_tab/FAQ_Screen.dart';
import '../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../core/resorces/Fonts_Manager.dart';
import '../../../../../services/User_1/profile_service.dart';
import '../../../../../services/local_storage_service.dart';
import '../../../Placeholder.dart';
import 'Account_tab/Applied_Courses_Screen.dart';
import 'Account_tab/Applied_Trainings_Screen.dart';
import 'Account_tab/Change_Password_Screen.dart';
import 'Account_tab/Edit_Profile_Screen.dart';
import 'Account_tab/Manage_Information_Documents.dart';
import 'Account_tab/Privacy_Policy_Screen.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? lastName;
  String? userId;
  String? profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _changeProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      // رفع الصورة
      final service = ProfileService();
      final uploadedUrl = await service.uploadFile(picked.path, 'profile');

      if (uploadedUrl != null) {
        // تحديث التخزين المحلي
        await LocalStorageService.updateProfileImage(uploadedUrl);

        // تحديث الواجهة
        setState(() {
          profileImage = uploadedUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image updated')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload failed, please try again.')),
        );
      }
    }
  }


  Future<void> _loadUserData() async {
    final data = await LocalStorageService.getLoginData();
    if (data != null) {
      setState(() {
        lastName = data['lastName'];
        userId = data['userId'];
        profileImage = data['profileImage'];
      });
    }
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
            // 1. قسم الملف الشخصي مع الصورة
            _buildProfileCard(context),

            // 2. الأقسام المختلفة
            _buildSection(
              context: context,
              title: 'My Applications',
              icon: Icons.analytics_outlined,
              items: [
                _buildListItem(
                   context: context,
                  icon: Icons.work_outline,
                  title: 'Applied Trainings',
                  onTap: () => _navigateToAppliedTrainings(context),
                ),
                _buildListItem(
                  context: context,
                  icon: Icons.school_outlined,
                  title: 'Applied Courses',
                  onTap: () => _navigateToAppliedCourses(context),
                ),
              ],
            ),

            _buildSection(
              context: context,
              title: 'Manage Profile',
              icon: Icons.manage_accounts_outlined,
              items: [
                _buildListItem(
                  context: context,
                  icon: Icons.folder_outlined,
                  title: 'Manage information & Documents',
                  onTap: () => _navigateToDocuments(context),
                ),
                _buildListItem(
                  context: context,
                  icon: Icons.edit_outlined,
                  title: 'Edit profile information',
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

            // 3. زر تسجيل الخروج
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(10) , left: Radius.circular(10))),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back , color: ColorsManager.primaryColor,),
        onPressed: () {
        },
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
              icon: const Icon(Icons.support_agent_outlined , color: ColorsManager.primaryColor,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeatureUnavailableScreen(title: 'Support'),
                  ),
                );
              },
            );
          }
        ),
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.settings , color: ColorsManager.primaryColor),
              onPressed: () {
                Navigator.pushNamed(context, "SettingsScreen");
              },
            );
          }
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
      margin:  EdgeInsets.only(left: screenWidth*0.045 , bottom: screenWidth*0.04 , right: screenWidth*0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: screenWidth * 0.01, // تباين حسب حجم الشاشة
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
                  child:  CircleAvatar(
                    radius: screenWidth*0.12,
                    backgroundImage: profileImage != null
                        ? NetworkImage(profileImage!)
                        : const AssetImage('assets/images/profile_placeholder.png') as ImageProvider,
                  ),
                ),
                Container(
                  width: screenWidth*0.1,
                  height: screenHeight*0.055,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorsManager.primaryColor , width: 1),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.edit, color: ColorsManager.primaryColor),
                    onPressed:_changeProfileImage,
                  ),
                ),
              ],
            ),
             SizedBox(height: screenHeight*0.016),
             Text(
               lastName ?? '...', // سيتم استبدالها بـ lastName من LocalStorageService
              style: TextStyle(
                fontSize: screenWidth*0.06,
                fontWeight: FontWeight.bold,
                fontFamily: FontsManager.GEDinkum,
              ),
            ),
             SizedBox(height: screenHeight*0.01),
            const Text(
              'Trainee / Training Seeker',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: screenHeight*0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  'ID: ${userId ?? "---"}', // سيتم استبدالها بـ userId من LocalStorageService
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(width: screenWidth*0.012),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(const ClipboardData(text: '10:00:001'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  child:  Icon(Icons.copy, size: screenWidth*0.04, color: ColorsManager.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context, // إضافة context كبارامتر
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04, // 4% من عرض الشاشة
        vertical: screenHeight * 0.013, // 1.5% من ارتفاع الشاشة
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03), // دائري بنسبة 3% من العرض
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: screenWidth * 0.01, // تباين حسب حجم الشاشة
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
                Icon(icon,
                  size: screenWidth * 0.065, // حجم الأيقونة 6% من العرض
                  color: ColorsManager.gray,
                ),
                SizedBox(width: screenWidth * 0.04),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045, // حجم الخط 4.5% من العرض
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

    return InkWell (
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.03,
        ),
        child: Row(
          children: [
            Icon(icon,
              size: screenWidth * 0.055,
              color: ColorsManager.primaryColor,
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                ),
              ),
            ),
            Icon(Icons.chevron_right),
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
            Icon(Icons.logout,
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
       ));
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
                // Warning Icon
                Icon(
                  Icons.warning_amber_rounded,
                  size: screenWidth * 0.15,
                  color: Colors.orange,
                ),
                SizedBox(height: screenHeight * 0.02),

                // Dialog Title
                Text(
                  'Confirm Logout',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsManager.GEDinkum,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Confirmation Message
                Text(
                  'Are you sure you want to log out of your account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                          side: BorderSide(color: ColorsManager.primaryColor),
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

                    // Logout Button
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
                          Navigator.pop(ctx); // Close dialog
                          _performLogout(context); // Execute logout
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
    // 1. Clear session from LocalStorage
    LocalStorageService.clearLoginData();

    // 2. Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // 3. Navigate to login screen
    Navigator.pushNamedAndRemoveUntil(
        context,
        "LoginWithEmailScreenScreen",
            (route) => false
    );
  }

  void _navigateToAppliedTrainings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AppliedTrainingsScreen()),
    );
  }

  void _navigateToAppliedCourses(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AppliedCoursesScreen()),
    );
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
      MaterialPageRoute(builder: (_) => const FeatureUnavailableScreen(title: 'FAQ & Help',)),
    );
  }

}

