// lib/presentations/widgets/User_1/training_opportunity_card.dart
import 'package:flutter/material.dart';
import '../../../core/resorces/Colors_Manager.dart';
import '../../../models/User_1/training_opportunity_model.dart';
import 'training_details_screen.dart';

class TrainingOpportunityCard extends StatefulWidget {
  final TrainingOpportunityModel training;

  const TrainingOpportunityCard({Key? key, required this.training}) : super(key: key);

  @override
  State<TrainingOpportunityCard> createState() => _TrainingOpportunityCardState();
}

class _TrainingOpportunityCardState extends State<TrainingOpportunityCard> {
  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    final training = widget.training;

    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TrainingDetailsScreen(training: training),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: w * 0.015, vertical: h * 0.01),
            padding: EdgeInsets.all(w * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(w * 0.035),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.12),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: w * 0.07,
                    backgroundColor: Colors.grey[200],
                    child: training.logoUrl.isNotEmpty
                        ? ClipOval(
                      child: Image.network(
                        training.logoUrl,
                        fit: BoxFit.cover,
                        width: w * 0.14,
                        height: w * 0.14,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('Failed to load image: ${training.logoUrl}, error: $error');
                          return Image.asset(
                            'assets/images/center_placeholder.png',
                            fit: BoxFit.cover,
                            width: w * 0.14,
                            height: w * 0.14,
                          );
                        },
                      ),
                    )
                        : Image.asset(
                      'assets/images/center_placeholder.png',
                      fit: BoxFit.cover,
                      width: w * 0.14,
                      height: w * 0.14,
                    ),
                  ),
                ),
                SizedBox(height: h * 0.01),
                Center(
                  child: Text(
                    training.companyName,
                    style: TextStyle(fontSize: w * 0.03, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: h * 0.008),
                Text(
                  training.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: w * 0.041,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                SizedBox(height: h * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoIcon(context, Icons.location_on_outlined, training.wilaya),
                    _buildInfoIcon(context, Icons.category_outlined, training.domain),
                  ],
                ),
                SizedBox(height: h * 0.01),
                _buildInfoIcon(context, Icons.schedule, 'Duration: ${training.duration}'),
                SizedBox(height: h * 0.01),
                _buildInfoIcon(context, Icons.calendar_today_outlined, 'Starts on: ${training.startDate}'),
                SizedBox(height: h * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TrainingDetailsScreen(training: training),
                            ),
                          );
                        },
                        icon: Icon(Icons.info_outline, size: w * 0.035, color: ColorsManager.primaryColor),
                        label: Text("Details", style: TextStyle(color: ColorsManager.primaryColor, fontSize: w * 0.028)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                          padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: 0),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorited ? Icons.bookmark : Icons.bookmark_border,
                        size: w * 0.05,
                        color: ColorsManager.primaryColor,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.005),
            decoration: const BoxDecoration(
              color: ColorsManager.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.work_outline, color: Colors.white, size: w * 0.038),
                SizedBox(width: w * 0.01),
                Text(
                  "Training",
                  style: TextStyle(color: Colors.white, fontSize: w * 0.027, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoIcon(BuildContext context, IconData icon, String value) {
    double w = MediaQuery.of(context).size.width;
    return Flexible(
      child: Row(
        children: [
          Icon(icon, size: w * 0.04, color: ColorsManager.primaryColor),
          SizedBox(width: w * 0.01),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: w * 0.03, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

