import 'package:fasting_repository/fasting_repository.dart';
import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/fasting.dart';

class FastingInfo extends StatelessWidget {
  final FastingSession session;

  const FastingInfo(
    this.session, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => ProgressRing(
        progress: session.progress,
        child: FastingInfoContent(
          elapsed: session.elapsed,
          remaining: session.remaining,
        ),
      );
}
