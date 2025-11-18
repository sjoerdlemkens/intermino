part of 'fasting_bloc.dart';

@immutable
sealed class FastingEvent {}

class FastStarted extends FastingEvent {}

class FastEnded extends FastingEvent {}
