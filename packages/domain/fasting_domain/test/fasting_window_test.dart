import 'package:test/test.dart';
import 'package:fasting_domain/fasting_domain.dart';

void main() {
  group('FastingWindow', () {
    test('has all expected enum values', () {
      expect(FastingWindow.values, contains(FastingWindow.sixteenEight));
      expect(FastingWindow.values, contains(FastingWindow.eighteenSix));
      expect(FastingWindow.values, contains(FastingWindow.omad));
    });

    test('has exactly 3 values', () {
      expect(FastingWindow.values.length, equals(3));
    });

    test('has correct enum value names', () {
      expect(FastingWindow.sixteenEight.name, equals('sixteenEight'));
      expect(FastingWindow.eighteenSix.name, equals('eighteenSix'));
      expect(FastingWindow.omad.name, equals('omad'));
    });

    test('has correct enum indices', () {
      expect(FastingWindow.sixteenEight.index, equals(0));
      expect(FastingWindow.eighteenSix.index, equals(1));
      expect(FastingWindow.omad.index, equals(2));
    });

    test('supports equality comparison', () {
      expect(FastingWindow.sixteenEight == FastingWindow.sixteenEight, isTrue);
      expect(FastingWindow.sixteenEight == FastingWindow.eighteenSix, isFalse);
      expect(FastingWindow.eighteenSix == FastingWindow.omad, isFalse);
    });

    test('all values are unique', () {
      final values = FastingWindow.values;
      final uniqueValues = values.toSet();
      expect(uniqueValues.length, equals(values.length));
    });
  });
}

