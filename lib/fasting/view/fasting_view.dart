import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/fasting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FastingView extends StatelessWidget {
  const FastingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FastingBloc, FastingState>(
      builder: (context, state) => switch (state) {
        FastingInitial() => FastingInitialView(),
        FastingInProgress() => FastingInProgressView(state),
      },
    );
  }
}
