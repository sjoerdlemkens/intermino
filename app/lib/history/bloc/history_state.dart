part of 'history_bloc.dart';

@immutable
sealed class HistoryState {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final DateTime currentMonth;
  final Map<DateTime, List<FastingSession>> fastingSessionsByDay;
  final List<FastingSession> lastFasts;
  final FastingSession? activeFast;

  const HistoryLoaded({
    required this.currentMonth,
    required this.fastingSessionsByDay,
    required this.lastFasts,
    this.activeFast,
  });
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);
}
