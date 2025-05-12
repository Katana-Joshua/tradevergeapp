// lib/core/utils/extensions.dart
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formattedDate => DateFormat('MMM d, yyyy').format(this);
  String get formattedDateTime => DateFormat('MMM d, yyyy HH:mm').format(this);
  String get formattedTime => DateFormat('HH:mm').format(this);

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get initials {
    if (isEmpty) return '';
    final parts = trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}

extension DoubleExtension on double {
  String get formatCurrency {
    return NumberFormat.currency(
      symbol: 'UGX ',
      decimalDigits: 0,
    ).format(this);
  }

  String get formatDistance {
    if (this < 1000) {
      return '${toStringAsFixed(0)}m';
    }
    return '${(this / 1000).toStringAsFixed(1)}km';
  }
}

extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  List<T> sortedBy<K extends Comparable<K>>(K Function(T) keyOf) {
    final list = toList();
    list.sort((a, b) => keyOf(a).compareTo(keyOf(b)));
    return list;
  }
}
