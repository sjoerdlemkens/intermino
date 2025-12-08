import 'package:flutter/material.dart';
import 'package:fasting_repository/fasting_repository.dart';

class CalendarDayWidget extends StatelessWidget {
  final DateTime date;
  final List<FastingSession> fastingSessions;
  final FastingSession? activeFast;
  final bool isToday;
  final bool isCurrentMonth;

  const CalendarDayWidget({
    super.key,
    required this.date,
    required this.fastingSessions,
    this.activeFast,
    this.isToday = false,
    this.isCurrentMonth = true,
  });

  /// Check if any fasting session on this day achieved its goal
  bool get _hasGoalAchieved {
    // Check active fast first if it's today
    if (isToday && activeFast != null) {
      return activeFast!.isGoalAchieved;
    }
    if (fastingSessions.isEmpty) return false;
    return fastingSessions.any((session) => session.isGoalAchieved);
  }

  /// Check if there are any fasting sessions on this day
  bool get _hasFast {
    if (isToday && activeFast != null) return true;
    return fastingSessions.isNotEmpty;
  }

  /// Get the ring color based on goal achievement
  Color? get _ringColor {
    if (!_hasFast) {
      // For today with no fast, return gray
      if (isToday) return Colors.grey[400];
      return null;
    }
    return _hasGoalAchieved
        ? const Color(0xFF4DB6AC) // Green for goal met
        : const Color(0xFF8DB6FD); // Blue for goal not met
  }

  @override
  Widget build(BuildContext context) {
    final hasRing = _ringColor != null;
    final ringColor = _ringColor;

    // For current day, determine if it should be filled
    final isFilledToday = isToday && hasRing;
    final fillColor = isFilledToday ? ringColor : null;

    final textColor = isCurrentMonth
        ? (isFilledToday ? Colors.white : Colors.black87)
        : Colors.grey[400];

    // If today is filled, show filled circle with text
    if (isFilledToday) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: fillColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      );
    }

    // If has ring but not today, show ring border (more compact and thicker)
    if (hasRing) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ringColor!,
            width: 3, // Thicker border
          ),
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ),
      );
    }

    // No ring - just show text
    return Center(
      child: Text(
        '${date.day}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          color: textColor,
        ),
      ),
    );
  }
}
