import 'package:flutter/material.dart';
import 'package:tamkin/core/resorces/Colors_Manager.dart';
import 'package:tamkin/core/resorces/Fonts_Manager.dart';
import 'package:tamkin/models/User_1/course_opportunity_model.dart';
import 'package:tamkin/services/Center_3/Training_Center_Services.dart';
import 'package:tamkin/services/local_storage_service.dart';

class OpportunityManagementScreen extends StatefulWidget {
  const OpportunityManagementScreen({super.key});

  @override
  State<OpportunityManagementScreen> createState() => _OpportunityManagementScreenState();
}

class _OpportunityManagementScreenState extends State<OpportunityManagementScreen> {
  final _service = TrainingCenterServices();
  List<CourseOpportunityModel> _opportunities = [];
  bool _isLoading = true;
  String? centerId;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadCenterData();
  }

  Future<void> _loadCenterData() async {
    final data = await LocalStorageService.getLoginData();
    if (data != null) {
      centerId = data['userId']?.toString();
      token = data['token']?.toString();
      if (centerId != null && token != null) {
        _loadOpportunities();
      }
    }
  }

  Future<void> _loadOpportunities() async {
    if (centerId == null || token == null) return;
    setState(() => _isLoading = true);
    try {
      final opportunities = await _service.fetchCenterPrograms(centerId!, token!);
      setState(() => _opportunities = opportunities);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() => _isLoading = false);
  }

  Future<void> _confirmAndDelete(String opportunityId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this opportunity?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      _deleteOpportunity(opportunityId);
    }
  }

  Future<void> _deleteOpportunity(String opportunityId) async {
    try {
      await _service.deleteOpportunity(opportunityId, token!);
      await _loadOpportunities();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opportunity deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Opportunity Management',
          style: TextStyle(
            color: ColorsManager.primaryColor,
            fontFamily: FontsManager.GEDinkum,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadOpportunities,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Opportunities',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontsManager.GEDinkum,
                  color: ColorsManager.primaryColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              if (_opportunities.isEmpty)
                Center(
                  child: Text(
                    'No opportunities found.',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.grey,
                      fontFamily: FontsManager.GEDinkum,
                    ),
                  ),
                )
              else
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _opportunities.length,
                  itemBuilder: (context, index) {
                    final opportunity = _opportunities[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.work_outline, color: ColorsManager.primaryColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    opportunity.courseTitle,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsManager.primaryColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text('Domain: ${opportunity.domain ?? 'N/A'}'),
                            Text('Start: ${opportunity.startDate ?? 'N/A'}'),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    // TODO: Navigate to Edit Screen
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmAndDelete(opportunity.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
