import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_app/app/app.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:settings_repository/settings_repository.dart';

class App extends StatelessWidget {
  final FastingRepository Function() createFastingRepo;

  const App({
    super.key,
    required this.createFastingRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FastingRepository>(
          create: (context) => createFastingRepo(),
        ),
        RepositoryProvider<SettingsRepository>(
          create: (context) => SettingsRepository(),
        )
      ],
      child: AppView(),
    );
  }
}
