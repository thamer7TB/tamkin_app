import 'package:flutter/material.dart';

class AppliedTrainingsScreen extends StatelessWidget {
  const AppliedTrainingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppliedTrainingsScreen')),
      body: const Center(child: Text('قائمة الدورات المسجلة')),
    );
  }
}