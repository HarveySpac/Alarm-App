import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmController {
  static final FlutterLocalNotificationsPlugin _alarmNotification =
      FlutterLocalNotificationsPlugin();

  static void _initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('icon'),
      iOS: DarwinInitializationSettings(),
    );

    _alarmNotification.initialize(initializationSettings);
  }

  static Future<NotificationDetails> _notificationDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return NotificationDetails(
      android: AndroidNotificationDetails(
          'you_can_name_it_whatever', 'flutterfcm',
          importance: Importance.high,
          ongoing: true,
          playSound: true,
          priority: Priority.high,
          sound: const RawResourceAndroidNotificationSound('venom')),
      iOS: const DarwinNotificationDetails(sound: 'assets/venom.mp3'),
    );
  }

  static Future<void> deleteReminder(
    int id,
  ) async {
    _alarmNotification.cancel(id);
  }

  static Future<void> updateReminder({
    required int id,
    String title = 'Reminder',
    required DateTime alarmStartTime,
    required DateTime alarmEndTime,
  }) async {
    deleteReminder(id).whenComplete(
      () => setAlarm(
        id: id,
        title: title,
        alarmStartTime: alarmStartTime,
      ),
    );
  }

  static Future<void> setAlarm({
    required int id,
    String title = 'Reminder',
    required DateTime alarmStartTime,
  }) async {
    _initialize();
    if (alarmStartTime.isAfter(DateTime.now())) {
      _alarmNotification.zonedSchedule(
        id,
        title,
        'Your Alarm is started',
        tz.TZDateTime.from(alarmStartTime, tz.UTC),
        await _notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
    }
  }

  static void showAlarm({
    required int id,
    String title = 'Reminder: WorkSchedule',
  }) {
    _initialize();

    _alarmNotification.show(
        id,
        title,
        'Your Alarm is started',
        NotificationDetails(
            android: AndroidNotificationDetails(
                'you_can_name_it_whatever', 'flutterfcm',
                importance: Importance.high,
                ongoing: true,
                playSound: true,
                priority: Priority.high,
                sound: const RawResourceAndroidNotificationSound('venom'))));
  }
}
