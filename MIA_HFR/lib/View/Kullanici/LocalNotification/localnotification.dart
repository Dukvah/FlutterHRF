import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  init() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
    var initializationSettingsAndroid =
        new AndroidInitializationSettings("app_icon");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    this.flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Bir Bildirimi Anlık Gösterme (Özel Bildirim Sesi ile)


  // TodoKey ile Bildirmi İptal Etme

  Future<void> cancelNotification({int key}) async {
    await this.flutterLocalNotificationsPlugin.cancel(key);
  }

  //Bir Bildirimi Belirli bir zaman göre Gösterme (Özel Bildirim Sesi ile)

  Future<void> schedule({
    int todoKey,
    String title,
    String bodyText,
    DateTime date,
  }) async {
     
    final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
        iOS: IOSNotificationDetails());
    this.flutterLocalNotificationsPlugin.zonedSchedule(
        todoKey,
        title,
        bodyText,
        tz.TZDateTime.from(date,tz.local),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
  }

}


// ignore: unused_element
tz.TZDateTime _customschdule() {
final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
if (scheduledDate.isBefore(now)) {
  scheduledDate = scheduledDate.add(const Duration(days: 1));
}
return scheduledDate;
}
  
