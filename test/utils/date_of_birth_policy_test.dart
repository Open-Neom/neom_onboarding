import 'package:flutter_test/flutter_test.dart';
import 'package:neom_onboarding/utils/date_of_birth_policy.dart';

void main() {
  group('DateOfBirthPolicy', () {
    test('accepts both selectable boundary dates', () {
      expect(DateOfBirthPolicy.isValid(DateTime(1930, 1, 1)), isTrue);
      expect(DateOfBirthPolicy.isValid(DateTime(2009, 12, 31)), isTrue);
    });

    test('rejects null and dates outside the selectable range', () {
      expect(DateOfBirthPolicy.isValid(null), isFalse);
      expect(DateOfBirthPolicy.isValid(DateTime(1929, 12, 31)), isFalse);
      expect(DateOfBirthPolicy.isValid(DateTime(2010, 1, 1)), isFalse);
      expect(DateOfBirthPolicy.isValid(DateTime(2010, 12, 31)), isFalse);
    });

    test('uses the latest valid date when no valid selection exists', () {
      expect(DateOfBirthPolicy.initialPickerDate(null), DateTime(2009, 12, 31));
      expect(
        DateOfBirthPolicy.initialPickerDate(DateTime(2010, 1, 1)),
        DateTime(2009, 12, 31),
      );
    });

    test('preserves a valid selection as a date-only picker value', () {
      expect(
        DateOfBirthPolicy.initialPickerDate(DateTime(1992, 6, 8, 14, 30)),
        DateTime(1992, 6, 8),
      );
    });
  });
}
