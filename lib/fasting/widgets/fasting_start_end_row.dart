import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/fasting.dart';

class FastingStartEndRow extends StatelessWidget {
  final DateTime started;
  final DateTime ending;

  const FastingStartEndRow({
    super.key,
    required this.started,
    required this.ending,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "STARTED FASTING",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    TimeFormatter.formatStartTime(started),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[600],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.orange[600],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "FAST ENDING",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                TimeFormatter.formatStartTime(ending),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
