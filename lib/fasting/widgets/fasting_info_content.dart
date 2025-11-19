import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/fasting.dart';

class FastingInfoContent extends StatelessWidget {
  final Duration elapsed;

  const FastingInfoContent({
    super.key,
    required this.elapsed,
  });

  @override
  Widget build(BuildContext context) {
    final elapsedFormatted = formatDuration(elapsed);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Elapsed time",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          elapsedFormatted,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Remaining",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "-- : -- : --",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
