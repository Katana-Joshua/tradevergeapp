import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_verge/features/notifications/providers/notification_provider.dart';

class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadCountProvider);

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Show notifications
            showModalBottomSheet(
              context: context,
              builder: (context) => const NotificationList(),
            );
          },
        ),
        unreadCount.when(
          data: (count) {
            if (count == 0) return const SizedBox.shrink();
            return Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class NotificationList extends ConsumerWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(notificationServiceProvider).markAllAsRead();
                },
                child: const Text('Mark all as read'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: notificationsAsync.when(
              data: (notifications) {
                if (notifications.isEmpty) {
                  return const Center(
                    child: Text('No notifications'),
                  );
                }

                return ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      title: Text(_getNotificationTitle(notification['type'])),
                      subtitle: Text(
                        _getNotificationMessage(notification),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        _formatTimestamp(notification['sent_at']),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () {
                        ref.read(notificationServiceProvider).markAsRead(notification['id']);
                        // Handle notification tap
                      },
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getNotificationTitle(String type) {
    switch (type) {
      case 'job_posted':
        return 'New Job Posted';
      case 'job_accepted':
        return 'Job Accepted';
      case 'job_arrived':
        return 'Transporter Arrived';
      case 'job_completed':
        return 'Job Completed';
      case 'payment_received':
        return 'Payment Received';
      case 'location_update':
        return 'Location Update';
      default:
        return 'Notification';
    }
  }

  String _getNotificationMessage(Map<String, dynamic> notification) {
    final payload = notification['payload'] as Map<String, dynamic>;
    switch (notification['type']) {
      case 'job_posted':
        return 'A new job has been posted';
      case 'job_accepted':
        return 'Your job has been accepted by a transporter';
      case 'job_arrived':
        return 'Transporter has arrived at pickup location';
      case 'job_completed':
        return 'Job has been completed successfully';
      case 'payment_received':
        return 'Payment of UGX ${payload['amount']} has been received';
      case 'location_update':
        return 'Transporter location has been updated';
      default:
        return 'New notification received';
    }
  }

  String _formatTimestamp(String timestamp) {
    final date = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}