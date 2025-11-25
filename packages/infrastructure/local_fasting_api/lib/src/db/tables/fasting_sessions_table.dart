import 'package:drift/drift.dart';

class FastingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime().nullable()();
  IntColumn get window =>
      integer().nullable()(); // window is added on fast completion
}
