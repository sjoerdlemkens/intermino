import 'package:fasting_app/fasting/edit_fasting_session/edit_fasting_session.dart';
import 'package:fasting_app/history/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/fasting/current_fasting_session/current_fasting_session.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_app/app/theme/theme.dart';

class EndFastDrawer extends StatefulWidget {
  final FastingSession session;

  const EndFastDrawer({
    required this.session,
    super.key,
  });

  static void show(BuildContext context, FastingSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CurrentFastingSessionBloc>(),
        child: EndFastDrawer(session: session),
      ),
    );
  }

  @override
  State<EndFastDrawer> createState() => _EndFastDrawerState();
}

class _EndFastDrawerState extends State<EndFastDrawer> {
  DateTime? _endTime;

  /// Get the session with the updated end time for preview purposes
  FastingSession get _previewSession {
    final endTime = _endTime ?? DateTime.now();
    return widget.session.copyWith(end: endTime);
  }

  void _onEndFastPressed(BuildContext context) {
    final fastingBloc = context.read<CurrentFastingSessionBloc>();
    final endTime = _endTime ?? DateTime.now();
    fastingBloc.add(FastEnded(endTime: endTime));
    Navigator.of(context).pop();
  }

  Future<void> _onDeleteFastPressed(BuildContext context) async {
    final confirmed = await ConfirmDeleteFastDialog.show(context);

    if (confirmed == true) {
      final fastingBloc = context.read<CurrentFastingSessionBloc>();
      fastingBloc.add(const FastCanceled());

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'End Fast',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                CompletedFastInfo(_previewSession),
                const SizedBox(height: AppSpacing.xl),

// TODO: Add the non editable start and editable end time cards.
                StartTimeCard(
                  startTime: widget.session.start,
                  iconColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                // Let the widget assume end time is now if not set
                EditableEndTimeCard(
                  endTime: _endTime ?? DateTime.now(),
                  iconColor: Theme.of(context).colorScheme.primary,
                  onEndTimeChanged: (newEndTime) {
                    final now = DateTime.now();
                    final startTime = widget.session.start;

                    // Clamp end time between start time and current time
                    final clampedEndTime = newEndTime.isBefore(startTime)
                        ? startTime
                        : (newEndTime.isAfter(now) ? now : newEndTime);

                    setState(() {
                      _endTime = clampedEndTime;
                    });
                  },
                ),

                const SizedBox(height: AppSpacing.lg),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _onDeleteFastPressed(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Delete Fast',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _onEndFastPressed(context),
                    style: FilledButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'End Fast',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
