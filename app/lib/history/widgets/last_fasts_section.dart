import 'package:flutter/material.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_app/history/history.dart';

class LastFastsSection extends StatelessWidget {
  final List<FastingSession> lastFasts;

  const LastFastsSection({
    super.key,
    required this.lastFasts,
  });

  @override
  Widget build(BuildContext context) {
    if (lastFasts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Last Fasts',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...lastFasts.map((session) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FastCard(session: session),
            )),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AllFastsView(),
                ),
              );
            },
            child: const Text(
              'View All Fasts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4DB6AC), // primary green
              ),
            ),
          ),
        ),
      ],
    );
  }
}
