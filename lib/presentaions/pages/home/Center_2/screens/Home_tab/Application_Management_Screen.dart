import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // تأكد من إضافة هذا في pubspec.yaml

class ApplicationManagementScreen extends StatelessWidget {
  // البيانات التجريبية (يمكنك استبدالها بالبيانات الحقيقية من API)
  final List<Map<String, dynamic>> applications = [
    {
      'id': 1,
      'status': 'Pending',
      'createdAt': '2025-05-01T12:34:56',
      'user': {
        'firstName': 'Ali',
        'lastName': 'Ahmed',
        'wilaya': 'Algiers',
        'phone': '+213123456789',
        'email': 'ali@example.com',
      },
    },
    {
      'id': 2,
      'status': 'Accepted',
      'createdAt': '2025-04-28T09:20:30',
      'user': {
        'firstName': 'Sara',
        'lastName': 'Benali',
        'wilaya': 'Oran',
        'phone': '+213987654321',
        'email': 'sara@example.com',
      },
    },
    // أضف بيانات أخرى حسب الحاجة
  ];

  ApplicationManagementScreen({Key? key}) : super(key: key);

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('User Details'),
        content: Text(
          'Name: ${user['firstName']} ${user['lastName']}\n'
              'Wilaya: ${user['wilaya']}\n'
              'Phone: ${user['phone']}\n'
              'Email: ${user['email']}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Close')),
        ],
      ),
    );
  }

  Future<void> _updateStatus(int id, String newStatus) async {
    // هنا تضع كود تحديث الحالة (API أو local state)
    print('Update app $id to $newStatus');
    // مجرد مثال للطباعة فقط
  }

  @override
  Widget build(BuildContext context) {
    // أخذ قياسات الشاشة
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Application Management'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.02),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: screenWidth * 0.03,
            mainAxisSpacing: screenHeight * 0.02,
            childAspectRatio: 3 / 4,
          ),
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final app = applications[index];
            final user = app['user'] ?? {};
            final status = app['status'] ?? 'Pending';

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.02)),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user['firstName'] ?? 'N/A'} ${user['lastName'] ?? ''}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Text(
                              'Wilaya: ${user['wilaya'] ?? 'N/A'}',
                              style: TextStyle(fontSize: screenWidth * 0.035),
                            ),
                            SizedBox(height: screenHeight * 0.006),
                            Text(
                              'Status: $status',
                              style: TextStyle(fontSize: screenWidth * 0.035),
                            ),
                            SizedBox(height: screenHeight * 0.006),
                            Text(
                              'Submitted: ${app['createdAt']?.split("T")[0] ?? 'N/A'}',
                              style: TextStyle(fontSize: screenWidth * 0.035),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ElevatedButton(
                      onPressed: () => _showDetailsDialog(context, user),
                      child: Text('View Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: Size(double.infinity, screenHeight * 0.045),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.phone, color: Colors.green, size: screenWidth * 0.07),
                          onPressed: () {
                            final phone = user['phone'];
                            if (phone != null) {
                              launchUrl(Uri.parse('tel:$phone'));
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.email, color: Colors.blue, size: screenWidth * 0.07),
                          onPressed: () {
                            final email = user['email'];
                            if (email != null) {
                              launchUrl(Uri.parse('mailto:$email'));
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check_circle, color: Colors.green, size: screenWidth * 0.09),
                          tooltip: 'Accept',
                          onPressed: () => _updateStatus(app['id'], 'Accepted'),
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red, size: screenWidth * 0.09),
                          tooltip: 'Reject',
                          onPressed: () => _updateStatus(app['id'], 'Rejected'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



