import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/fasting/fasting.dart';

class FastingInProgressView extends StatelessWidget {
  final FastingInProgress state;

  const FastingInProgressView(this.state, {super.key});

  void _onEndFastPressed(BuildContext context) {
    final fastingBloc = context.read<FastingBloc>();
    fastingBloc.add(FastEnded());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _onEndFastPressed(context),
        child: const Text('End Fast'),
      ),
    );
  }
}
