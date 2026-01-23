import 'package:notifications_api/notifications_api.dart';

abstract class NotificationsApi {
  Future<Notification> createNotification({
    required String titleTKey,
    required String bodyTKey,
  });

  Future<Notification> getNotification(int id);

  Future<List<Notification>> getNotifications();

  Future<void> deleteNotification(int id);
}
