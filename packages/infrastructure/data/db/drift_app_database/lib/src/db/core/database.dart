import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import '../tables/tables.dart';
import 'package:notifications_api/notifications_api.dart' show Notification;
import 'package:fasting_api/fasting_api.dart' show FastingSession;

part 'database.g.dart';

@DriftDatabase(tables: [FastingSessions, Notifications])
class DriftAppDatabase extends _$DriftAppDatabase {
  DriftAppDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() => LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    await dir.create(recursive: true);

    final file = File(path.join(dir.path, 'fasting.db'));
    return NativeDatabase(file);
  });
}
