import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mia_hfr/Model/Alarm.dart';
import 'package:mia_hfr/View/Kullanici/LocalNotification/AlarmHelper.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../main.dart';
import 'LocalNotification/localnotification.dart';

class KullaniciAyarlar extends StatefulWidget {
  @override
  _KullaniciAyarlarState createState() => _KullaniciAyarlarState();
}

class _KullaniciAyarlarState extends State<KullaniciAyarlar> {
  DateTime _alarmTime;
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>> _alarms;
  List<AlarmInfo> _currentAlarms;
  String zaman;
  DateTime time;
  var selectedDateTime;
  DateTime date;
  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
        ),
        body: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: FutureBuilder(
                  future: _alarms,
                  builder: (context, snapshot) {
                    _currentAlarms = snapshot.data;
                    if (snapshot.hasData) {
                      return ListView(
                        children: snapshot.data.map<Widget>((alarm) {
                          var alarmTime = DateFormat('dd/MM/yyyy hh:mm')
                              .format(alarm.alarmDateTime);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 32),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.blue[800],
                                    Colors.deepPurple[400]
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              boxShadow: [],
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.label,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          alarm.title,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      alarmTime,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'avenir',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      DateFormat.E('tr_TR')
                                          .format(alarm.alarmDateTime),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'avenir',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.white,
                                      onPressed: () {
                                        deleteAlarm(alarm.id);
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).followedBy([
                          if (_currentAlarms.length < 5)
                            DottedBorder(
                              dashPattern: [5.4],
                              strokeWidth: 3,
                              borderType: BorderType.RRect,
                              radius: Radius.circular(24),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent[400],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                // ignore: deprecated_member_use
                                child: FlatButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  onPressed: () async {
                                    Random rnd = new Random();
                                    int random =
                                        rnd.nextInt(100); //!INTEGER DEGISECEK
                                    LocalNotification notification =
                                        LocalNotification();
                                    notification.init();
                                    await DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2020, 3, 8),
                                        maxTime: DateTime(2050, 6, 7),
                                        onChanged: (date) {},
                                        onConfirm: (date) {
                                      DatePicker.showTimePicker(
                                        context,
                                        showTitleActions: true,
                                        onConfirm: (time) async {
                                          if (DateTime.now().isBefore(time)) {
                                            try {
                                              await notification.schedule(
                                                todoKey: random,
                                                title: 'Mia-HFR Bildirim',
                                                bodyText: zaman = DateFormat(
                                                            'dd/MM/yyyy')
                                                        .format(date) +
                                                    " " +
                                                    DateFormat('hh:mm')
                                                        .format(time) +
                                                    " Lütfen HFR'lerinizi Giriniz.",
                                                date: time,
                                              );
                                              selectedDateTime = DateTime(
                                                  date.year,
                                                  date.month,
                                                  date.day,
                                                  time.hour,
                                                  time.minute);
                                              _alarmTime = selectedDateTime;
                                              onSaveAlarm();
                                            } catch (ex) {
                                              return showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Hata'),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: [
                                                          Text(
                                                              'Mia-HFR Bildirim'),
                                                          Text(
                                                              'Bildirim Oluştururken bir hata oluştu lütfen tekrar deneyiniz.'),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      // ignore: deprecated_member_use
                                                      FlatButton(
                                                        child: Text('Kapat'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          } else {
                                            return showDialog(
                                              context: context,
                                              barrierDismissible:
                                                  false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Uyarı'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: [
                                                        Text(
                                                            'Lütfen Bildirimi kontrol ediniz.'),
                                                        Text(
                                                            'Girmiş Olduğunuz zaman kavramı şuan geçerli değildir, lütfen tekrar deneyiniz.'),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    // ignore: deprecated_member_use
                                                    FlatButton(
                                                      child: Text('Kapat'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      );
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset(
                                        'images/add_alarm.png',
                                        scale: 1.5,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Bildirim Ekle",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          else
                            Center(
                                child: Text(
                              'Sadece 5 Tane Bildirim Ekleyebilirsiniz.',
                              style: TextStyle(color: Colors.white),
                            )),
                        ]).toList(),
                      );
                    }
                    return Center(
                        child: Text(
                      "Yükleniyor..",
                      style: TextStyle(color: Colors.black),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scheduleAlarm({
    int todoKey,
    String title,
    String bodyText,
    int year,
    int month,
    int day,
    int oclock,
    int minute,
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
    flutterLocalNotificationsPlugin.zonedSchedule(
        todoKey,
        title,
        bodyText,
        tz.TZDateTime(tz.local, year, month, day, oclock, minute),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  void onSaveAlarm() async {
    //  await schedule....
    //

    DateTime scheduleAlarmDateTime;
    if (_alarmTime.isBefore(DateTime.now()))
      scheduleAlarmDateTime = _alarmTime;
    else
      scheduleAlarmDateTime = _alarmTime;

    var alarmInfo = AlarmInfo(
      alarmDateTime: scheduleAlarmDateTime,
      title: 'Mia-HFR Bildirim',
    );
    _alarmHelper.insertAlarm(alarmInfo);
    loadAlarms();
  }

  void deleteAlarm(int id) {
    _alarmHelper.delete(id);
    loadAlarms();
  }
}
