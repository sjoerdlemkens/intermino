import 'package:fasting_app/fasting/fasting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FastingInitialView extends StatelessWidget {
  const FastingInitialView({super.key});

  void _onStartFastPressed(BuildContext context) {
    final fastingBloc = context.read<FastingBloc>();
    fastingBloc.add(FastStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _onStartFastPressed(context),
        child: const Text('Start Fast'),
      ),
    );
  }
}
