// lib/core/utils/number_utils.dart
import 'package:intl/intl.dart';

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