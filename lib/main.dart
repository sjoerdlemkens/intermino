import 'package:flutter/material.dart';
import 'package:fasting_app/app/app.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:local_fasting_api/local_fasting_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final fastingApi = LocalFastingApi();

  runApp(
    App(
      createFastingRepo: () => FastingRepository(
        fastingApi: fastingApi,
      ),
    ),
  );
}
