import 'package:fasting_app/history/history.dart';
import 'package:fasting_app/misc/misc.dart';
import 'package:fasting_app/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';

class AllFastsView extends StatelessWidget {
  const AllFastsView({super.key});

  @override
  Widget build(BuildContext context) {
    final fastingRepository = context.read<FastingRepository>();

    return BlocProvider(
      create: (context) => AllFastsBloc(
        getMonthlyHistory: GetMonthlyHistoryUseCase(
          fastingRepository: fastingRepository,
        ),
      )..add(LoadAllFastsMonth(DateTime.now())),
      child: Scaffold(
        appBar: const HomeAppBar.withTitle('All Fasts'),
        body: const _AllFastsViewContent(),
      ),
    );
  }
}

class _AllFastsViewContent extends StatelessWidget {
  const _AllFastsViewContent();

  void _onPreviousMonthPressed(BuildContext context, DateTime currentMonth) {
    final previousMonth = DateTime(
      currentMonth.year,
      currentMonth.month - 1,
    );

    final bloc = context.read<AllFastsBloc>();
    bloc.add(ChangeAllFastsMonth(previousMonth));
  }

  void _onNextMonthPressed(BuildContext context, DateTime currentMonth) {
    final nextMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
    );

    final bloc = context.read<AllFastsBloc>();
    bloc.add(ChangeAllFastsMonth(nextMonth));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllFastsBloc, AllFastsState>(
      builder: (context, state) => switch (state) {
        AllFastsInitial() || AllFastsLoading() => const LoadingView(),
        AllFastsError() => Center(
            child: Text("error: ${state.message}"),
          ), // TODO: implement reusable error view
        AllFastsLoaded() => Column(
            children: [
              MonthSelector(
                currentMonth: state.currentMonth,
                onPreviousMonth: () =>
                    _onPreviousMonthPressed(context, state.currentMonth),
                onNextMonth: () =>
                    _onNextMonthPressed(context, state.currentMonth),
              ),
              Expanded(
                child: state.fastingSessions.isEmpty
                    ? const Center(
                        child: Text(
                          'No fasting sessions found for this month',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.fastingSessions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: FastCard(
                              session: state.fastingSessions[index],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
      },
    );
  }
}
