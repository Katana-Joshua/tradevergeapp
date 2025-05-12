import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> subscribeToNotifications() {
    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('status', 'sent')
        .order('sent_at', ascending: false)
        .map((notifications) => notifications);
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'status': 'read'}).eq('id', notificationId);
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _supabase
          .from('notifications')
          .update({'status': 'read'}).eq('status', 'sent');
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _supabase
          .from('notifications')
          .select('*')
          .eq('status', 'sent');

      return (response as List).length;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }
}
