import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tamkin/core/resorces/Colors_Manager.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';
import 'package:tamkin/models/User_1/center_model.dart';
import 'package:tamkin/services/local_storage_service.dart';
import 'Home_tab/Application_Management_Screen.dart';
import 'Home_tab/Create_Opportunity_Screen.dart';
import 'Home_tab/Opportunity_Management_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CenterModel? _center;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadCenterData();
  }

  Future<void> _loadCenterData() async {
    final data = await LocalStorageService.getLoginData();
    if (data != null) {
      setState(() {
        _center = CenterModel(
          id: data['userId'] ?? '',
          name: data['lastName'] ?? 'Training Center',
          logoUrl: data['profileImage'] ?? '',
        );
        _token = data['token']?.toString();
        // تعديل مسار الـ logoUrl إذا كان يحتوي على uploads/
        if (_center!.logoUrl.isNotEmpty && !_center!.logoUrl.startsWith('http')) {
          final baseUrl = 'https://tamkeens.up.railway.app/';
          final logoPath = 'download/';
          _center = _center!.copyWith(
            logoUrl: '$baseUrl$logoPath${_center!.logoUrl.replaceFirst('uploads/', '')}',
          );
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorsManager.UserGrayScaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: ColorsManager.primaryColor,
            fontFamily: FontsManager.GEDinkum,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: ColorsManager.primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_center != null)
              Row(
                children: [
                  _center!.logoUrl.isNotEmpty
                      ? FutureBuilder<Uint8List>(
                    future: _loadNetworkImageWithAuth(_center!.logoUrl, _token),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                          radius: screenWidth * 0.06,
                          backgroundColor: Colors.grey[200],
                          child: const CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return CircleAvatar(
                          radius: screenWidth * 0.06,
                          backgroundImage: const AssetImage('assets/images/center_placeholder.png') as ImageProvider,
                        );
                      } else if (snapshot.hasData) {
                        return CircleAvatar(
                          radius: screenWidth * 0.06,
                          backgroundImage: MemoryImage(snapshot.data!),
                        );
                      }
                      return CircleAvatar(
                        radius: screenWidth * 0.06,
                        backgroundImage: const AssetImage('assets/images/center_placeholder.png') as ImageProvider,
                      );
                    },
                  )
                      : CircleAvatar(
                    radius: screenWidth * 0.06,
                    backgroundImage: const AssetImage('assets/images/center_placeholder.png') as ImageProvider,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'Welcome, ${_center!.name}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsManager.GEDinkum,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                ],
              ),
            SizedBox(height: screenHeight * 0.02),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.add_circle_outline, color: ColorsManager.primaryColor),
                title: Text(
                  'Create New Opportunity',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: ColorsManager.primaryColor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateOpportunityScreen()),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'Management Tools',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                fontFamily: FontsManager.GEDinkum,
                color: ColorsManager.primaryColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: screenWidth * 0.03,
              mainAxisSpacing: screenHeight * 0.02,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildToolCard(
                  context: context,
                  title: 'Opportunity Management',
                  icon: Icons.list_alt,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OpportunityManagementScreen()),
                    );
                  },
                ),
                _buildToolCard(
                  context: context,
                  title: 'Application Management',
                  icon: Icons.person_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) =>  ApplicationManagementScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: screenWidth * 0.08, color: ColorsManager.primaryColor),
              SizedBox(height: screenHeight * 0.01),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: ColorsManager.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// إضافة دالة copyWith لـ CenterModel
extension CenterModelExtension on CenterModel {
  CenterModel copyWith({String? id, String? name, String? logoUrl}) {
    return CenterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
}