import 'package:drift/drift.dart';

class Fasts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get start => dateTime()();
}
