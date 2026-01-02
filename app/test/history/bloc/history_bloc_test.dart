import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fasting_app/history/history.dart';
import 'package:fasting_repository/fasting_repository.dart';

class MockFastingRepository extends Mock implements FastingRepository {}

void main() {
  group('HistoryBloc', () {
    late FastingRepository mockFastingRepo;
    late HistoryBloc historyBloc;

    setUp(() {
      mockFastingRepo = MockFastingRepository();
      historyBloc = HistoryBloc(
        fastingRepo: mockFastingRepo,
      );
    });

    tearDown(() {
      historyBloc.close();
    });

    test('initial state is HistoryInitial', () {
      expect(historyBloc.state, equals(const HistoryInitial()));
    });

    group('LoadHistoryMonth', () {
      final testMonth = DateTime(2025, 11, 15); // November 2025
      final mockSessions = [
        FastingSession(
          id: 1,
          start: DateTime(2025, 11, 5, 8, 0),
          end: DateTime(2025, 11, 6, 0, 0),
          window: FastingWindow.sixteenEight,
        ),
        FastingSession(
          id: 2,
          start: DateTime(2025, 11, 10, 18, 0),
          end: DateTime(2025, 11, 11, 12, 0),
          window: FastingWindow.eighteenSix,
        ),
      ];

      blocTest<HistoryBloc, HistoryState>(
        'emits [HistoryLoading, HistoryLoaded] when LoadHistoryMonth succeeds',
        build: () {
          // Mock monthly history sessions
          when(() => mockFastingRepo.getFastingSessions(
                startAfter: any(named: 'startAfter'),
                startBefore: any(named: 'startBefore'),
                isActive: false,
              )).thenAnswer((_) async => mockSessions);
          // Mock recent fasts
          when(() => mockFastingRepo.getFastingSessions(
                isActive: false,
                limit: 3,
              )).thenAnswer((_) async => []);
          // Mock active fast
          when(() => mockFastingRepo.getFastingSessions(
                limit: 1,
                isActive: true,
              )).thenAnswer((_) async => []);
          return historyBloc;
        },
        act: (bloc) => bloc.add(LoadHistoryMonth(testMonth)),
        expect: () => [
          const HistoryLoading(),
          isA<HistoryLoaded>()
              .having((state) => state.currentMonth, 'currentMonth', testMonth)
              .having(
                (state) => state.fastingSessionsByDay.length,
                'sessionsByDay length',
                2,
              )
              .having(
                (state) => state.lastFasts,
                'lastFasts',
                isEmpty,
              )
              .having(
                (state) => state.activeFast,
                'activeFast',
                isNull,
              ),
        ],
        verify: (_) {
          verify(() => mockFastingRepo.getFastingSessions(
                startAfter: any(named: 'startAfter'),
                startBefore: any(named: 'startBefore'),
                isActive: false,
              )).called(1);
          verify(() => mockFastingRepo.getFastingSessions(
                isActive: false,
                limit: 3,
              )).called(1);
          verify(() => mockFastingRepo.getFastingSessions(
                limit: 1,
                isActive: true,
              )).called(1);
        },
      );

      blocTest<HistoryBloc, HistoryState>(
        'emits [HistoryLoading, HistoryError] when LoadHistoryMonth fails',
        build: () {
          when(() => mockFastingRepo.getFastingSessions(
                startAfter: any(named: 'startAfter'),
                startBefore: any(named: 'startBefore'),
                isActive: false,
              )).thenThrow(Exception('Failed to load sessions'));
          return historyBloc;
        },
        act: (bloc) => bloc.add(LoadHistoryMonth(testMonth)),
        expect: () => [
          const HistoryLoading(),
          isA<HistoryError>().having((state) => state.message, 'error message',
              contains('Failed to load sessions')),
        ],
      );

      blocTest<HistoryBloc, HistoryState>(
        'emits [HistoryLoading, HistoryLoaded] with empty sessions when no data',
        build: () {
          when(() => mockFastingRepo.getFastingSessions(
                startAfter: any(named: 'startAfter'),
                startBefore: any(named: 'startBefore'),
                isActive: false,
              )).thenAnswer((_) async => []);
          when(() => mockFastingRepo.getFastingSessions(
                isActive: false,
                limit: 3,
              )).thenAnswer((_) async => []);
          when(() => mockFastingRepo.getFastingSessions(
                limit: 1,
                isActive: true,
              )).thenAnswer((_) async => []);
          return historyBloc;
        },
        act: (bloc) => bloc.add(LoadHistoryMonth(testMonth)),
        expect: () => [
          const HistoryLoading(),
          isA<HistoryLoaded>()
              .having((state) => state.currentMonth, 'currentMonth', testMonth)
              .having(
                (state) => state.fastingSessionsByDay.isEmpty,
                'empty sessionsByDay',
                true,
              )
              .having(
                (state) => state.lastFasts,
                'lastFasts',
                isEmpty,
              )
              .having(
                (state) => state.activeFast,
                'activeFast',
                isNull,
              ),
        ],
      );
    });

    group('ChangeMonth', () {
      final testMonth = DateTime(2025, 12, 1);

      blocTest<HistoryBloc, HistoryState>(
        'triggers LoadHistoryMonth with new month',
        build: () {
          when(() => mockFastingRepo.getFastingSessions(
                startAfter: any(named: 'startAfter'),
                startBefore: any(named: 'startBefore'),
                isActive: false,
              )).thenAnswer((_) async => []);
          when(() => mockFastingRepo.getFastingSessions(
                isActive: false,
                limit: 3,
              )).thenAnswer((_) async => []);
          when(() => mockFastingRepo.getFastingSessions(
                limit: 1,
                isActive: true,
              )).thenAnswer((_) async => []);
          return historyBloc;
        },
        act: (bloc) => bloc.add(ChangeMonth(testMonth)),
        expect: () => [
          const HistoryLoading(),
          isA<HistoryLoaded>()
              .having((state) => state.currentMonth, 'currentMonth', testMonth),
        ],
        verify: (_) {
          verify(() => mockFastingRepo.getFastingSessions(
                startAfter: any(named: 'startAfter'),
                startBefore: any(named: 'startBefore'),
                isActive: false,
              )).called(1);
          verify(() => mockFastingRepo.getFastingSessions(
                isActive: false,
                limit: 3,
              )).called(1);
          verify(() => mockFastingRepo.getFastingSessions(
                limit: 1,
                isActive: true,
              )).called(1);
        },
      );
    });
  });
}
