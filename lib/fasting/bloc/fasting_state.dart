part of 'fasting_bloc.dart';

@immutable
sealed class FastingState {
  const FastingState();
}

final class FastingInitial extends FastingState {
  const FastingInitial();
}

final class FastingLoading extends FastingState {
  const FastingLoading();
}

final class FastingInProgress extends FastingState {
  final FastingSession session;

  const FastingInProgress({
    required this.session,
  });

  FastingInProgress copyWith({
    FastingSession? session,
  }) {
    return FastingInProgress(
      session: session ?? this.session,
    );
  }
}
