import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

void main() {
  runApp(MaterialApp(
    title: 'Lab 10.5 Notifications',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      useMaterial3: true,
    ),
    home: const NotificationPage(),
  ));
}

/// Hub entry (no nested MaterialApp — root MaterialApp is in main.dart).
class NotificationApp extends StatelessWidget {
  const NotificationApp({super.key});

  @override
  Widget build(BuildContext context) => const NotificationPage();
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isSupported = false;

  @override
  void initState() {
    super.initState();
    // Thông báo cục bộ chỉ hỗ trợ Android/iOS/MacOS/Linux trong thư viện này
    _isSupported = Platform.isAndroid || Platform.isIOS;
    if (_isSupported) {
      _initNotifications();
    }
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification() async {
    if (!_isSupported) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifications are not supported on Windows in this lab.')));
      return;
    }
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('lab10_channel_id', 'Lab 10 Notifications', importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Lab 10 Notification', 'You triggered a local notification.', platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isSupported)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Note: Notifications will only work on Android/iOS Emulator.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                FilledButton(
                  onPressed: _showNotification,
                  child: const Text('Show Notification'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
