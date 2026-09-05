import 'package:neom_core/utils/constants/core_constants.dart';

/// Single source of truth for the date-of-birth range used during onboarding.
///
/// [CoreConstants.lastYearDOB] is an exclusive boundary: a date of birth must
/// be before January 1 of that year. Consequently, the latest selectable date
/// is December 31 of the preceding year.
abstract final class DateOfBirthPolicy {
  static DateTime get earliestSelectableDate =>
      DateTime(CoreConstants.firstYearDOB, 1, 1);

  static DateTime get latestSelectableDate =>
      DateTime(CoreConstants.lastYearDOB - 1, 12, 31);

  static bool isValid(DateTime? dateOfBirth) {
    if (dateOfBirth == null) return false;

    final dateKey = _dateKey(dateOfBirth);
    return dateKey >= _dateKey(earliestSelectableDate) &&
        dateKey <= _dateKey(latestSelectableDate);
  }

  /// Returns a valid, date-only value for opening the date picker.
  static DateTime initialPickerDate(DateTime? dateOfBirth) {
    if (!isValid(dateOfBirth)) return latestSelectableDate;

    return DateTime(dateOfBirth!.year, dateOfBirth.month, dateOfBirth.day);
  }

  static int _dateKey(DateTime date) =>
      date.year * 10000 + date.month * 100 + date.day;
}
