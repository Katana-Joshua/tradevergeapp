// lib/core/utils/list_utils.dart
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  List<T> sortedBy<K extends Comparable<K>>(K Function(T) keyOf) {
    final list = toList();
    list.sort((a, b) => keyOf(a).compareTo(keyOf(b)));
    return list;
  }
}