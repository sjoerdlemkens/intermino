import 'package:fasting_app/misc/misc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/history/history.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final fastingRepository = context.read<FastingRepository>();

    return BlocProvider(
      create: (context) => HistoryBloc(
        getMonthlyHistory: GetMonthlyHistoryUseCase(
          fastingRepository: fastingRepository,
        ),
        getRecentFasts: GetRecentFastsUseCase(
          fastingRepository: fastingRepository,
        ),
        getActiveFast: GetActiveFastUseCase(
          fastingRepo: fastingRepository,
        ),
      )..add(LoadHistoryMonth(DateTime.now())),
      child: const _HistoryViewContent(),
    );
  }
}

class _HistoryViewContent extends StatelessWidget {
  const _HistoryViewContent();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) => switch (state) {
            HistoryInitial() || HistoryLoading() => LoadingView(),
            HistoryError() => Center(
                child: Text("error"),
              ), // TODO: implement reusable error view

            HistoryLoaded() => HistoryLoadedView(state),
          },
        ),
      );
}
