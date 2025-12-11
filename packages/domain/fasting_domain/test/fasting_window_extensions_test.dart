import 'package:test/test.dart';
import 'package:fasting_domain/fasting_domain.dart';

void main() {
  group('FastingWindowExtensions', () {
    group('duration', () {
      test('returns 16 hours for sixteenEight window', () {
        expect(
          FastingWindow.sixteenEight.duration,
          equals(const Duration(hours: 16)),
        );
      });

      test('returns 18 hours for eighteenSix window', () {
        expect(
          FastingWindow.eighteenSix.duration,
          equals(const Duration(hours: 18)),
        );
      });

      test('returns 23 hours for omad window', () {
        expect(FastingWindow.omad.duration, equals(const Duration(hours: 23)));
      });
    });
  });
}
