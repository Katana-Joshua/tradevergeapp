import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/notifications/services/notification_service.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());

final notificationsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.subscribeToNotifications();
});

final unreadCountProvider = StreamProvider<int>((ref) async* {
  final service = ref.watch(notificationServiceProvider);
  
  while (true) {
    try {
      final count = await service.getUnreadCount();
      yield count;
      await Future.delayed(const Duration(seconds: 30));
    } catch (e) {
      // Handle error
      yield 0;
    }
  }
});