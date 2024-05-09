import 'package:frontend/utils/constants/constants.dart';
import 'package:intl/intl.dart';

class TConverter {
  TConverter._();
  static String intTo2Digits(int number) => number.toString().padLeft(2, '0');

  static String valueToString(dynamic value) {
    switch (value) {
      case String _:
        return value;
      case bool _:
        return value ? YES : NO;
      case DateTime _:
        return dateTimeToStringFormate(date: value);
      case null:
        return EMPTY_STRING;
      default:
        return value.toString();
    }
  }

  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat(DATE_FORMAT);
    return formatter.format(dateTime);
  }

  static String dateTimeToStringFormate(
      {DateTime? date, String defaultValue = EMPTY_DATE_FORMATE}) {
    return date
            ?.toIso8601String()
            .split('T')
            .map((str) => str.contains(UNDERSCORE)
                ? str.split(UNDERSCORE).reversed.join(SLASH)
                : str.split('.')[0]) // Remove milliseconds
            .join(' ') ??
        defaultValue;
  }

  /// Convert a Google Sheets date to a DateTime
  static DateTime? dateFromGsheet(String gsheetDate) {
    if (gsheetDate.isEmpty) return null;
    return DateTime.now();
    // }
    // final googleSheetsDateTime = double.tryParse(gsheetDate) ?? 0;
    // // Calculate the number of milliseconds from the epoch
    // final millisecondsFromEpoch =
    //     (googleSheetsDateTime * GSHEETS_DAY_IN_MILLISECONDS).round();
    // // Add milliseconds to the epoch to get the desired DateTime
    // final dateTimeFromGoogleSheets =
    //     GOOGLE_SHEETS_EPOCH.add(Duration(milliseconds: millisecondsFromEpoch));
    // return dateTimeFromGoogleSheets;
  }

  static Duration durationFromGsheet(String duration) {
    if (duration.isEmpty) {
      return Duration.zero;
    }
    var parts = duration.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }

  static String durationToString(Duration duration) {
    if (duration.isNegative) {
      return ZERO_DURATION_STRING_FORMATE;
    }

    final days = duration.inDays.toString();
    final hours = intTo2Digits(duration.inHours.remainder(24));
    final minutes = intTo2Digits(duration.inMinutes.remainder(60));
    final seconds = intTo2Digits(duration.inSeconds.remainder(60));

    return '$days:$hours:$minutes:$seconds';
  }

  /// Get the range for the paginated table.
  ///
  /// [currentPage] the current page in the paginated table.
  /// [rowsPerPage] the number of rows per page.
  /// [startCol] the starting column for example 'A'.
  /// [endCol] the ending column for example 'Z'(optional).
  static String range(int currentPage, int rowsPerPage,
      {String startCol = 'A', String endCol = ''}) {
    // skip the first row
    final start = (currentPage - 1) * rowsPerPage + 2;
    final end = currentPage * rowsPerPage;
    return '$startCol$start:$endCol$end';
  }

  static Iterable<String> fill(List<String> list, int newLength) {
    final toExtend = (newLength - list.length).abs();
    return List.filled(toExtend, '').toList();
  }
}
