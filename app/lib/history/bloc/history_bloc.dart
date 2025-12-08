import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:meta/meta.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetMonthlyHistoryUseCase _getMonthlyHistory;
  final GetRecentFastsUseCase _getRecentFasts;
  final GetActiveFastUseCase _getActiveFast;

  HistoryBloc({
    required GetMonthlyHistoryUseCase getMonthlyHistory,
    required GetRecentFastsUseCase getRecentFasts,
    required GetActiveFastUseCase getActiveFast,
  })  : _getMonthlyHistory = getMonthlyHistory,
        _getRecentFasts = getRecentFasts,
        _getActiveFast = getActiveFast,
        super(const HistoryInitial()) {
    on<LoadHistoryMonth>(_onLoadHistoryMonth);
    on<ChangeMonth>(_onChangeMonth);
  }

  Future<void> _onLoadHistoryMonth(
    LoadHistoryMonth event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());

    try {
      final month = event.month;
      final sessionsByDay = await _getMonthlyHistory(month);
      final lastFasts = await _getRecentFasts();
      final activeFast = await _getActiveFast();

      emit(HistoryLoaded(
        currentMonth: month,
        fastingSessionsByDay: sessionsByDay,
        lastFasts: lastFasts,
        activeFast: activeFast,
      ));
    } catch (error) {
      emit(HistoryError(error.toString()));
    }
  }

  Future<void> _onChangeMonth(
    ChangeMonth event,
    Emitter<HistoryState> emit,
  ) async {
    add(LoadHistoryMonth(event.month));
  }
}
