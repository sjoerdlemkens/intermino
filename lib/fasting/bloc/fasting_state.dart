part of 'fasting_bloc.dart';

@immutable
sealed class FastingState {}

final class FastingInitial extends FastingState {}

final class FastingInProgress extends FastingState {}
