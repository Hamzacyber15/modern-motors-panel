import 'package:flutter/cupertino.dart';

extension GetMediaQuery on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;
}

extension SizeExtension on int {
  SizedBox get w => SizedBox(width: toDouble());

  SizedBox get h => SizedBox(height: toDouble());
}

extension DoubleSizedBoxExtension on double {
  SizedBox get dh => SizedBox(height: this);

  SizedBox get dw => SizedBox(width: this);
}

extension DateTimeDifferenceExtension on DateTime {
  String differenceFrom(DateTime other) {
    Duration diff =
        difference(other).abs(); // abs() ensures positive difference

    int days = diff.inDays;
    int hours = diff.inHours % 24;
    int minutes = diff.inMinutes % 60;

    String result = '';
    if (days > 0) result += '$days day${days > 1 ? 's' : ''} ';
    if (hours > 0) result += '$hours hour${hours > 1 ? 's' : ''} ';
    if (minutes > 0) result += '$minutes min${minutes > 1 ? 's' : ''}';

    return result.trim().isEmpty ? '0 min' : result.trim();
  }
}

extension TimeDifferenceExtension on DateTime {
  String get timeDifferenceFromNow {
    final now = DateTime.now();
    final difference = this.difference(now);

    if (difference.inDays.abs() >= 1) {
      final days = difference.inDays.abs();
      return difference.isNegative
          ? '$days day${days == 1 ? '' : 's'} ago'
          : 'in $days day${days == 1 ? '' : 's'}';
    } else if (difference.inHours.abs() >= 1) {
      final hours = difference.inHours.abs();
      return difference.isNegative
          ? '$hours hour${hours == 1 ? '' : 's'} ago'
          : 'in $hours hour${hours == 1 ? '' : 's'}';
    } else {
      final minutes = difference.inMinutes.abs();
      return difference.isNegative
          ? '$minutes minute${minutes == 1 ? '' : 's'} ago'
          : 'in $minutes minute${minutes == 1 ? '' : 's'}';
    }
  }
}

extension StringCasingExtension on String {
  /// Capitalizes only the first letter (rest remains unchanged)
  String get capitalizeFirst =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;

  /// Capitalizes first letter and makes rest lowercase
  String get capitalizeFirstOnly => isNotEmpty
      ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
      : this;
}

extension FormattedDateExtensions on DateTime {
  /// Example: 04 Jul 2025
  String get formattedWithDayMonthYear {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String day = this.day.toString().padLeft(2, '0');
    String month = months[this.month - 1];
    String yearStr = year.toString();
    return '$day $month $yearStr';
  }

  /// Example: Jul 2025
  String get formattedWithMonthYear {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String monthStr = months[month - 1];
    String yearStr = year.toString();
    return '$monthStr $yearStr';
  }

  /// Example: 10-Aug
  String get formattedDayMonth {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String monthStr = months[month - 1];

    String days = day.toString();
    return '$days-$monthStr';
  }
}

extension FormattedDateForExcelNameExtensions on DateTime {
  /// Example: 2025-Jul-04 14-23-05
  String get formattedWithYMDHMS {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String day = this.day.toString().padLeft(2, '0');
    String month = months[this.month - 1];
    String yearStr = year.toString();
    // String hour = this.hour.toString().padLeft(2, '0');
    // String minute = this.minute.toString().padLeft(2, '0');
    String second = this.second.toString().padLeft(2, '0');

    int hour = this.hour;
    String amPm = hour >= 12 ? 'PM' : 'AM';

    // Convert 24-hour time to 12-hour time
    hour = hour % 12;
    hour =
        hour == 0 ? 12 : hour; // The hour '0' should be '12' in 12-hour format

    String minute = this.minute.toString().padLeft(2, '0');

    return '$yearStr-$month-$day $hour-$minute-$second';
  }

  /// Example: Jul 2025
  String get formattedWithMonthYear {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String monthStr = months[month - 1];
    String yearStr = year.toString();
    return '$monthStr $yearStr';
  }
}

extension FormattedDateForNameExtensions on DateTime {
  /// Example: 2025-Jul-04 14-23-Am
  String get formattedWithYMDHMSAM {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String day = this.day.toString().padLeft(2, '0');
    String month = months[this.month - 1];
    String yearStr = year.toString();
    // String hour = this.hour.toString().padLeft(2, '0');
    // String minute = this.minute.toString().padLeft(2, '0');
    String second = this.second.toString().padLeft(2, '0');

    int hour = this.hour;
    String amPm = hour >= 12 ? 'PM' : 'AM';

    // Convert 24-hour time to 12-hour time
    hour = hour % 12;
    hour =
        hour == 0 ? 12 : hour; // The hour '0' should be '12' in 12-hour format

    String minute = this.minute.toString().padLeft(2, '0');

    return '$yearStr-$month-$day $hour:$minute $amPm';
  }

  /// Example: Jul 2025
  String get formattedWithMonthYear {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String monthStr = months[month - 1];
    String yearStr = year.toString();
    return '$monthStr $yearStr';
  }
}

extension FormateDateTimeWithDays on DateTime {
  String get dayOfTheWeek {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    String weekday = weekdays[this.weekday - 1];
    String month = months[this.month - 1];
    String day = this.day.toString().padLeft(2, '0');

    return '$weekday $month $day';
  }
}

extension FormateJustTime on DateTime {
  String get justTime {
    int hour = this.hour;
    String amPm = hour >= 12 ? 'PM' : 'AM';

    // Convert 24-hour time to 12-hour time
    hour = hour % 12;
    hour =
        hour == 0 ? 12 : hour; // The hour '0' should be '12' in 12-hour format

    String minute = this.minute.toString().padLeft(2, '0');

    return '$hour:$minute $amPm';
  }
}

extension FollowersFormatter on int {
  String get formatCount {
    if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(1).removeTrailingZero()}B';
    } else if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1).removeTrailingZero()}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1).removeTrailingZero()}K';
    } else {
      return toString();
    }
  }
}

extension ReadableAmount on double {
  String get toReadable {
    if (this >= 1e9) {
      return "${(this / 1e9).toStringAsFixed(1)}B";
    } else if (this >= 1e6) {
      return "${(this / 1e6).toStringAsFixed(1)}M";
    } else if (this >= 1e3) {
      return "${(this / 1e3).toStringAsFixed(1)}K";
    } else {
      return toStringAsFixed(1);
    }
  }
}

// Helper extension to remove trailing .0
extension StringZeroTrimmer on String {
  String removeTrailingZero() {
    return replaceAll(
      RegExp(r'([.]\d*?[1-9])0+$'),
      r'\1',
    ).replaceAll(RegExp(r'[.]0+$'), '');
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension WeekdayNameExtension on int {
  String get weekdayName {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (this < 1 || this > 7) return '';
    return names[this - 1];
  }
}

extension RotatedWeekdayExtension on DateTime {
  List<String> get rotatedWeekdays {
    const original = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    int firstWeekday =
        DateTime(year, month, 1).weekday; // 1 = Mon, ..., 7 = Sun
    int startIndex = firstWeekday - 1; // 0-based index
    return [
      ...original.sublist(startIndex),
      ...original.sublist(0, startIndex),
    ];
  }
}

extension IntToOpacity on int {
  double get toOpacity {
    if (this < 100) return 0.2;
    if (this < 200) return 0.5;
    return 1.0;
  }
}

extension DurationSmartFormat on Duration {
  /// Returns duration as: `2d 5h 20m`
  /// - 24 hours se kam: `6h 23m`
  /// - 1 din ya zyada: `1d 2h 9m`
  /// - Sirf minutes: `18m`
  String toSmartString({bool showSeconds = false}) {
    if (inSeconds < 60) {
      return showSeconds ? '${inSeconds}s' : '0m';
    }
    final days = inDays;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    final buffer = StringBuffer();
    if (days > 0) buffer.write('${days}d ');
    if (hours > 0) buffer.write('${hours}h ');
    if (minutes > 0) buffer.write('${minutes}m');
    if (days == 0 && hours == 0 && minutes == 0 && showSeconds) {
      buffer.write('${seconds}s');
    }

    return buffer.toString().trim();
  }
}
