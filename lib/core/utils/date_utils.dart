// lib/core/utils/date_utils.dart
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formattedDate => DateFormat('MMM d, yyyy').format(this);
  String get formattedDateTime => DateFormat('MMM d, yyyy HH:mm').format(this);
  String get formattedTime => DateFormat('HH:mm').format(this);

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}