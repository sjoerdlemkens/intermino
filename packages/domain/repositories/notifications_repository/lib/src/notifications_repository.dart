import 'package:notifications_api/notifications_api.dart';

class NotificationsRepository {
  final NotificationsApi _notificationsApi;

  const NotificationsRepository({required NotificationsApi notificationsApi})
    : _notificationsApi = notificationsApi;

  Future<Notification> createNotification({
    required String titleTKey,
    required String bodyTKey,
  }) async {
    final notification = await _notificationsApi.createNotification(
      titleTKey: titleTKey,
      bodyTKey: bodyTKey,
    );

    return notification;
  }

  Future<Notification> getNotification(int id) =>
      _notificationsApi.getNotification(id);

  Future<List<Notification>> getNotifications() =>
      _notificationsApi.getNotifications();

  Future<void> deleteNotification(int id) =>
      _notificationsApi.deleteNotification(id);
}
