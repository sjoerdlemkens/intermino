import 'package:test/test.dart';
import 'package:fasting_repository/fasting_repository.dart';

void main() {
  group('FastingSession', () {
    final fixedStartTime = DateTime(2025, 3, 15, 12, 0, 0);

    group('isActive', () {
      test('returns true when end is null', () {
        final session = FastingSession(
          start: fixedStartTime,
          window: FastingWindow.sixteenEight,
        );

        expect(session.isActive, isTrue);
      });

      test('returns false when end is not null', () {
        final session = FastingSession(
          start: fixedStartTime,
          end: fixedStartTime.add(FastingWindow.sixteenEight.duration),
          window: FastingWindow.sixteenEight,
        );

        expect(session.isActive, isFalse);
      });
    });

    group('endsOn', () {
      test('returns start + window duration for sixteenEight window', () {
        final session = FastingSession(
          start: fixedStartTime,
          window: FastingWindow.sixteenEight,
        );

        final expectedEnd = fixedStartTime.add(
          FastingWindow.sixteenEight.duration,
        );
        expect(session.endsOn, equals(expectedEnd));
      });

      test('returns start + window duration for eighteenSix window', () {
        final session = FastingSession(
          start: fixedStartTime,
          window: FastingWindow.eighteenSix,
        );

        final expectedEnd = fixedStartTime.add(
          FastingWindow.eighteenSix.duration,
        );
        expect(session.endsOn, equals(expectedEnd));
      });

      test('returns start + window duration for omad window', () {
        final session = FastingSession(
          start: fixedStartTime,
          window: FastingWindow.omad,
        );

        final expectedEnd = fixedStartTime.add(FastingWindow.omad.duration);
        expect(session.endsOn, equals(expectedEnd));
      });

      test('returns DateTime.now() when window is null', () {
        final beforeNow = DateTime.now();
        final session = FastingSession(start: fixedStartTime, window: null);
        final afterNow = DateTime.now();

        // endsOn should be between beforeNow and afterNow (or equal to one of them)
        expect(
          session.endsOn.isAfter(
            beforeNow.subtract(const Duration(milliseconds: 1)),
          ),
          isTrue,
        );
        expect(
          session.endsOn.isBefore(
            afterNow.add(const Duration(milliseconds: 1)),
          ),
          isTrue,
        );
      });
    });

    group('elapsed', () {
      test(
        'returns difference between end and start for completed session',
        () {
          final endTime = fixedStartTime.add(
            FastingWindow.sixteenEight.duration,
          );
          final session = FastingSession(
            start: fixedStartTime,
            end: endTime,
            window: FastingWindow.sixteenEight,
          );

          expect(session.elapsed, equals(FastingWindow.sixteenEight.duration));
        },
      );

      test('returns difference between now and start for active session', () {
        final beforeNow = DateTime.now();
        final session = FastingSession(
          start: fixedStartTime,
          window: FastingWindow.sixteenEight,
        );
        final afterNow = DateTime.now();

        final elapsed = session.elapsed;
        final minElapsed = beforeNow.difference(fixedStartTime);
        final maxElapsed = afterNow.difference(fixedStartTime);

        // Allow small margin for test execution time
        expect(
          elapsed.inMilliseconds,
          greaterThanOrEqualTo(minElapsed.inMilliseconds - 10),
        );
        expect(
          elapsed.inMilliseconds,
          lessThanOrEqualTo(maxElapsed.inMilliseconds + 10),
        );
      });

      test('returns zero for session that just started', () {
        final now = DateTime.now();
        final session = FastingSession(
          start: now,
          window: FastingWindow.sixteenEight,
        );

        // Allow small margin for test execution time
        expect(session.elapsed.inMilliseconds, lessThan(100));
      });
    });

    group('remaining', () {
      test('returns remaining duration when goal not reached', () {
        // Mock elapsed time by using a session that started 4 hours ago
        final fourHoursAgo = DateTime.now().subtract(const Duration(hours: 4));
        final sessionWithElapsed = FastingSession(
          start: fourHoursAgo,
          window: FastingWindow.sixteenEight,
        );

        final remaining = sessionWithElapsed.remaining;
        // Should be approximately 12 hours remaining (16 - 4)
        expect(remaining.inHours, greaterThanOrEqualTo(11));
        expect(remaining.inHours, lessThanOrEqualTo(13));
      });

      test('returns zero when goal is achieved', () {
        final sixteenHoursAgo = DateTime.now().subtract(
          FastingWindow.sixteenEight.duration,
        );
        final session = FastingSession(
          start: sixteenHoursAgo,
          window: FastingWindow.sixteenEight,
        );

        expect(session.remaining, equals(Duration.zero));
      });

      test('returns zero when elapsed exceeds window duration', () {
        final twentyHoursAgo = DateTime.now().subtract(
          const Duration(hours: 20),
        );
        final session = FastingSession(
          start: twentyHoursAgo,
          window: FastingWindow.sixteenEight,
        );

        expect(session.remaining, equals(Duration.zero));
      });

      test('returns zero when window is null', () {
        final session = FastingSession(start: fixedStartTime, window: null);

        expect(session.remaining, equals(Duration.zero));
      });

      test('returns correct remaining for completed session', () {
        final start = fixedStartTime;
        final end = fixedStartTime.add(const Duration(hours: 10));
        final session = FastingSession(
          start: start,
          end: end,
          window: FastingWindow.sixteenEight,
        );

        // 16 hours goal - 10 hours elapsed = 6 hours remaining
        expect(session.remaining, equals(const Duration(hours: 6)));
      });

      test('returns zero for completed session that exceeded goal', () {
        final start = fixedStartTime;
        final end = fixedStartTime.add(const Duration(hours: 20));
        final session = FastingSession(
          start: start,
          end: end,
          window: FastingWindow.sixteenEight,
        );

        expect(session.remaining, equals(Duration.zero));
      });
    });

    group('progress', () {
      test('returns 0.0 when window is null', () {
        final session = FastingSession(start: fixedStartTime, window: null);

        expect(session.progress, equals(0.0));
      });

      test('returns 0.0 for session that just started', () {
        final now = DateTime.now();
        final session = FastingSession(
          start: now,
          window: FastingWindow.sixteenEight,
        );

        expect(session.progress, equals(0.0));
      });

      test('returns 0.5 when halfway through goal', () {
        final eightHoursAgo = DateTime.now().subtract(const Duration(hours: 8));
        final session = FastingSession(
          start: eightHoursAgo,
          window: FastingWindow.sixteenEight,
        );

        // Progress should be approximately 0.5 (8/16)
        expect(session.progress, closeTo(0.5, 0.1));
      });

      test('returns 1.0 when goal is achieved', () {
        final sixteenHoursAgo = DateTime.now().subtract(
          FastingWindow.sixteenEight.duration,
        );
        final session = FastingSession(
          start: sixteenHoursAgo,
          window: FastingWindow.sixteenEight,
        );

        expect(session.progress, equals(1.0));
      });

      test('returns 1.0 when elapsed exceeds goal', () {
        final twentyHoursAgo = DateTime.now().subtract(
          const Duration(hours: 20),
        );
        final session = FastingSession(
          start: twentyHoursAgo,
          window: FastingWindow.sixteenEight,
        );

        expect(session.progress, equals(1.0));
      });

      test('returns correct progress for completed session', () {
        final start = fixedStartTime;
        final end = fixedStartTime.add(const Duration(hours: 8));
        final session = FastingSession(
          start: start,
          end: end,
          window: FastingWindow.sixteenEight,
        );

        // 8 hours / 16 hours = 0.5
        expect(session.progress, equals(0.5));
      });

      test('clamps progress to 1.0 for completed session exceeding goal', () {
        final start = fixedStartTime;
        final end = fixedStartTime.add(const Duration(hours: 20));
        final session = FastingSession(
          start: start,
          end: end,
          window: FastingWindow.sixteenEight,
        );

        expect(session.progress, equals(1.0));
      });

      test('returns correct progress for eighteenSix window', () {
        final nineHoursAgo = DateTime.now().subtract(const Duration(hours: 9));
        final session = FastingSession(
          start: nineHoursAgo,
          window: FastingWindow.eighteenSix,
        );

        // 9 hours / 18 hours = 0.5
        expect(session.progress, closeTo(0.5, 0.1));
      });
    });

    group('isGoalAchieved', () {
      test('returns false when window is null', () {
        final session = FastingSession(start: fixedStartTime, window: null);

        expect(session.isGoalAchieved, isFalse);
      });

      test('returns false when goal not reached', () {
        final eightHoursAgo = DateTime.now().subtract(const Duration(hours: 8));
        final session = FastingSession(
          start: eightHoursAgo,
          window: FastingWindow.sixteenEight,
        );

        expect(session.isGoalAchieved, isFalse);
      });

      test('returns true when goal is exactly achieved', () {
        final sixteenHoursAgo = DateTime.now().subtract(
          FastingWindow.sixteenEight.duration,
        );
        final session = FastingSession(
          start: sixteenHoursAgo,
          window: FastingWindow.sixteenEight,
        );

        expect(session.isGoalAchieved, isTrue);
      });

      test('returns true when elapsed exceeds goal', () {
        final twentyHoursAgo = DateTime.now().subtract(
          const Duration(hours: 20),
        );
        final session = FastingSession(
          start: twentyHoursAgo,
          window: FastingWindow.sixteenEight,
        );

        expect(session.isGoalAchieved, isTrue);
      });

      test('returns true for completed session that achieved goal', () {
        final start = fixedStartTime;
        final end = fixedStartTime.add(FastingWindow.sixteenEight.duration);
        final session = FastingSession(
          start: start,
          end: end,
          window: FastingWindow.sixteenEight,
        );

        expect(session.isGoalAchieved, isTrue);
      });

      test('returns false for completed session that did not achieve goal', () {
        final start = fixedStartTime;
        final end = fixedStartTime.add(const Duration(hours: 10));
        final session = FastingSession(
          start: start,
          end: end,
          window: FastingWindow.sixteenEight,
        );

        expect(session.isGoalAchieved, isFalse);
      });

      test('returns true for omad window when 23 hours elapsed', () {
        final twentyThreeHoursAgo = DateTime.now().subtract(
          FastingWindow.omad.duration,
        );
        final session = FastingSession(
          start: twentyThreeHoursAgo,
          window: FastingWindow.omad,
        );

        expect(session.isGoalAchieved, isTrue);
      });
    });

    group('copyWith', () {
      test(
        'returns new instance with same values when no parameters provided',
        () {
          final original = FastingSession(
            id: 1,
            start: fixedStartTime,
            end: fixedStartTime.add(FastingWindow.sixteenEight.duration),
            window: FastingWindow.sixteenEight,
          );

          final copy = original.copyWith();

          expect(copy.id, equals(original.id));
          expect(copy.start, equals(original.start));
          expect(copy.end, equals(original.end));
          expect(copy.window, equals(original.window));
          expect(copy, isNot(same(original)));
        },
      );

      test('returns new instance with updated id', () {
        final original = FastingSession(
          id: 1,
          start: fixedStartTime,
          window: FastingWindow.sixteenEight,
        );

        final copy = original.copyWith(id: 2);

        expect(copy.id, equals(2));
        expect(copy.start, equals(original.start));
        expect(copy.end, equals(original.end));
        expect(copy.window, equals(original.window));
      });

      test('returns new instance with updated start', () {
        final original = FastingSession(
          start: fixedStartTime,
          window: FastingWindow.sixteenEight,
        );
        final newStart = fixedStartTime.add(const Duration(hours: 1));

        final copy = original.copyWith(start: newStart);

        expect(copy.start, equals(newStart));
        expect(copy.window, equals(original.window));
      });

      test('returns new instance with updated end', () {
        final original = FastingSession(
          start: fixedStartTime,
          window: FastingWindow.sixteenEight,
        );
        final newEnd = fixedStartTime.add(FastingWindow.sixteenEight.duration);

        final copy = original.copyWith(end: newEnd);

        expect(copy.end, equals(newEnd));
        expect(copy.start, equals(original.start));
        expect(copy.window, equals(original.window));
      });

      test('returns new instance with updated window', () {
        final original = FastingSession(
          start: fixedStartTime,
          window: FastingWindow.sixteenEight,
        );

        final copy = original.copyWith(window: FastingWindow.eighteenSix);

        expect(copy.window, equals(FastingWindow.eighteenSix));
        expect(copy.start, equals(original.start));
      });

      test('preserves end when end parameter is null in copyWith', () {
        final originalEnd = fixedStartTime.add(
          FastingWindow.sixteenEight.duration,
        );
        final original = FastingSession(
          start: fixedStartTime,
          end: originalEnd,
          window: FastingWindow.sixteenEight,
        );

        // copyWith uses ?? operator, so passing null preserves the original value
        final copy = original.copyWith(end: null);

        expect(copy.end, equals(originalEnd));
        expect(copy.start, equals(original.start));
        expect(copy.window, equals(original.window));
      });

      test('returns new instance with multiple updated fields', () {
        final original = FastingSession(
          id: 1,
          start: fixedStartTime,
          window: FastingWindow.sixteenEight,
        );
        final newEnd = fixedStartTime.add(FastingWindow.eighteenSix.duration);

        final copy = original.copyWith(
          id: 2,
          end: newEnd,
          window: FastingWindow.eighteenSix,
        );

        expect(copy.id, equals(2));
        expect(copy.end, equals(newEnd));
        expect(copy.window, equals(FastingWindow.eighteenSix));
        expect(copy.start, equals(original.start));
      });
    });

    group('constructor', () {
      test('creates instance with all fields', () {
        final end = fixedStartTime.add(FastingWindow.sixteenEight.duration);
        final session = FastingSession(
          id: 1,
          start: fixedStartTime,
          end: end,
          window: FastingWindow.sixteenEight,
        );

        expect(session.id, equals(1));
        expect(session.start, equals(fixedStartTime));
        expect(session.end, equals(end));
        expect(session.window, equals(FastingWindow.sixteenEight));
      });

      test('creates instance with required fields only', () {
        final session = FastingSession(
          start: fixedStartTime,
          window: FastingWindow.sixteenEight,
        );

        expect(session.id, isNull);
        expect(session.start, equals(fixedStartTime));
        expect(session.end, isNull);
        expect(session.window, equals(FastingWindow.sixteenEight));
      });

      test('creates instance with null window', () {
        final session = FastingSession(start: fixedStartTime, window: null);

        expect(session.window, isNull);
        expect(session.start, equals(fixedStartTime));
      });
    });
  });
}
