import 'package:fasting_app/history/widgets/completed_fast_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/fasting/current_fasting_session/current_fasting_session.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_app/app/theme/theme.dart';

class EndFastDrawer extends StatelessWidget {
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

  void _onEndFastPressed(BuildContext context) {
    final fastingBloc = context.read<CurrentFastingSessionBloc>();
    fastingBloc.add(FastEnded());
    Navigator.of(context).pop();
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
                CompletedFastInfo(session),
                const SizedBox(height: AppSpacing.xl),

// TODO: Add the non editable start and editable end time cards. 
// //  StartTimeCard(
//             startTime: session.start,
//             iconColor: theme.colorScheme.primary,
//             onStartTimeChanged: isUpdating
//                 ? null
//                 : (newStartTime) =>
//                     _onStartTimeChanged(context, newStartTime, session),
//           ),
//           const SizedBox(height: AppSpacing.md),
//           EditableEndTimeCard(
//             endTime: session.end,
//             iconColor: theme.colorScheme.primary,
//             onEndTimeChanged: isUpdating
//                 ? null
//                 : (newEndTime) =>
//                     _onEndTimeChanged(context, newEndTime, session),
//           ),


                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
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
                    onPressed: () {},
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
