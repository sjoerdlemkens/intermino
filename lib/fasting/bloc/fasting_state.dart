part of 'fasting_bloc.dart';

@immutable
sealed class FastingState extends Equatable {
  const FastingState();

  @override
  List<Object?> get props => [];
}

final class FastingInitial extends FastingState {
  const FastingInitial();
}

final class FastingInProgress extends FastingState {
  final DateTime started;
  final Duration elapsed;

  const FastingInProgress({
    required this.started,
    this.elapsed = Duration.zero,
  });

  FastingInProgress copyWith({
    DateTime? started,
    Duration? elapsed,
  }) {
    return FastingInProgress(
      started: started ?? this.started,
      elapsed: elapsed ?? this.elapsed,
    );
  }

  @override
  List<Object?> get props => [elapsed];
}
