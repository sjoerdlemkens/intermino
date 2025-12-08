import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fasting_app/history/history.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';

class MockGetMonthlyHistoryUseCase extends Mock
    implements GetMonthlyHistoryUseCase {}

class MockGetRecentFastsUseCase extends Mock implements GetRecentFastsUseCase {}

class MockGetActiveFastUseCase extends Mock implements GetActiveFastUseCase {}

void main() {
  group('HistoryBloc', () {
    late GetMonthlyHistoryUseCase mockGetMonthlyHistory;
    late GetRecentFastsUseCase mockGetRecentFasts;
    late GetActiveFastUseCase mockGetActiveFast;
    late HistoryBloc historyBloc;

    setUp(() {
      mockGetMonthlyHistory = MockGetMonthlyHistoryUseCase();
      mockGetRecentFasts = MockGetRecentFastsUseCase();
      mockGetActiveFast = MockGetActiveFastUseCase();
      historyBloc = HistoryBloc(
        getMonthlyHistory: mockGetMonthlyHistory,
        getRecentFasts: mockGetRecentFasts,
        getActiveFast: mockGetActiveFast,
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
      final mockSessionsByDay = {
        DateTime(2025, 11, 5): [
          FastingSession(
            id: 1,
            start: DateTime(2025, 11, 5, 8, 0),
            end: DateTime(2025, 11, 6, 0, 0),
            window: FastingWindow.sixteenEight,
          ),
        ],
        DateTime(2025, 11, 10): [
          FastingSession(
            id: 2,
            start: DateTime(2025, 11, 10, 18, 0),
            end: DateTime(2025, 11, 11, 12, 0),
            window: FastingWindow.eighteenSix,
          ),
        ],
      };

      blocTest<HistoryBloc, HistoryState>(
        'emits [HistoryLoading, HistoryLoaded] when LoadHistoryMonth succeeds',
        build: () {
          when(() => mockGetMonthlyHistory(any()))
              .thenAnswer((_) async => mockSessionsByDay);
          when(() => mockGetRecentFasts()).thenAnswer((_) async => []);
          when(() => mockGetActiveFast()).thenAnswer((_) async => null);
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
          verify(() => mockGetMonthlyHistory(testMonth)).called(1);
          verify(() => mockGetRecentFasts()).called(1);
          verify(() => mockGetActiveFast()).called(1);
        },
      );

      blocTest<HistoryBloc, HistoryState>(
        'emits [HistoryLoading, HistoryError] when LoadHistoryMonth fails',
        build: () {
          when(() => mockGetMonthlyHistory(any()))
              .thenThrow(Exception('Failed to load sessions'));
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
          when(() => mockGetMonthlyHistory(any())).thenAnswer((_) async => {});
          when(() => mockGetRecentFasts()).thenAnswer((_) async => []);
          when(() => mockGetActiveFast()).thenAnswer((_) async => null);
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
          when(() => mockGetMonthlyHistory(any())).thenAnswer((_) async => {});
          when(() => mockGetRecentFasts()).thenAnswer((_) async => []);
          when(() => mockGetActiveFast()).thenAnswer((_) async => null);
          return historyBloc;
        },
        act: (bloc) => bloc.add(ChangeMonth(testMonth)),
        expect: () => [
          const HistoryLoading(),
          isA<HistoryLoaded>()
              .having((state) => state.currentMonth, 'currentMonth', testMonth),
        ],
        verify: (_) {
          verify(() => mockGetMonthlyHistory(testMonth)).called(1);
          verify(() => mockGetRecentFasts()).called(1);
          verify(() => mockGetActiveFast()).called(1);
        },
      );
    });
  });
}
