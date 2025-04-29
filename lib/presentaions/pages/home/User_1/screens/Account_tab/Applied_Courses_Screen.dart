

import 'package:flutter/material.dart';

class AppliedCoursesScreen extends StatelessWidget {
  const AppliedCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Applied Courses')),
      body: const Center(child: Text('قائمة الدورات المسجلة')),
    );
  }
}