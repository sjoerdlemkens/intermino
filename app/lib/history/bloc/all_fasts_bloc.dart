import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:meta/meta.dart';

part 'all_fasts_event.dart';
part 'all_fasts_state.dart';

class AllFastsBloc extends Bloc<AllFastsEvent, AllFastsState> {
  final FastingRepository _fastingRepo;

  AllFastsBloc({
    required FastingRepository fastingRepo,
  })  : _fastingRepo = fastingRepo,
        super(const AllFastsInitial()) {
    on<LoadAllFastsMonth>(_onLoadAllFastsMonth);
    on<ChangeAllFastsMonth>(_onChangeAllFastsMonth);
  }

  Future<void> _onLoadAllFastsMonth(
    LoadAllFastsMonth event,
    Emitter<AllFastsState> emit,
  ) async {
    emit(const AllFastsLoading());

    try {
      final month = event.month;

      // Get monthly history
      final firstDayOfMonth = DateTime(month.year, month.month, 1);
      final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

      final sessions = await _fastingRepo.getFastingSessions(
        startAfter: firstDayOfMonth.subtract(const Duration(days: 1)),
        startBefore: lastDayOfMonth.add(const Duration(days: 1)),
        isActive: false, // Only get completed sessions for history
      );

      // Group sessions by day
      final sessionsByDay = <DateTime, List<FastingSession>>{};
      for (final session in sessions) {
        final day = DateTime(
          session.start.year,
          session.start.month,
          session.start.day,
        );
        sessionsByDay.putIfAbsent(day, () => []).add(session);
      }

      // Flatten the map into a single list of sessions, sorted by start time (newest first)
      final allSessions = <FastingSession>[];
      for (final sessions in sessionsByDay.values) {
        allSessions.addAll(sessions);
      }
      allSessions.sort((a, b) => b.start.compareTo(a.start));

      emit(AllFastsLoaded(
        currentMonth: month,
        fastingSessions: allSessions,
      ));
    } catch (error) {
      emit(AllFastsError(error.toString()));
    }
  }

  Future<void> _onChangeAllFastsMonth(
    ChangeAllFastsMonth event,
    Emitter<AllFastsState> emit,
  ) async {
    add(LoadAllFastsMonth(event.month));
  }
}
