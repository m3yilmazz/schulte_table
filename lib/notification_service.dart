import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final List<String> _baitMessages = [
    "Your brain is slowing down. Time for a 60-second warmup!",
    "Someone just beat your Reaction Time record... probably.",
    "Can you find the number 1 faster today?",
    "Your peripheral vision needs exercise. Jump in!",
    "Daily visual training is waiting for you.",
    "It's been a while since you challenged your memory.",
    "Is your focus slipping today? Prove it wrong.",
    "Quick! 60 seconds of concentration training.",
    "Your high score in Classic Mode is looking a bit low...",
    "Train your eyes, train your mind. Let's go!",
    "Schulte Tables: The ultimate brain gym. Open now.",
    "Are you faster than you were yesterday?",
    "Don't lose your streak! Time for a quick mental workout.",
    "Sharpen your focus before your next meeting.",
    "A sharp mind requires daily maintenance. Tap to start.",
    "Can you beat your best time right now?",
    "Challenge accepted? Open the app to find out.",
    "Your brain called... it wants a challenge.",
    "Speed reading starts here. Practice your peripheral vision.",
    "Just 1 minute of Schulte Tables can boost your focus."
  ];

  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/schulte_table_app_icon');
    
    // For iOS if ever needed
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap if needed
      },
    );
  }

  Future<bool> requestPermissions() async {
    final bool? result = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
    
    final bool? notifResult = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    return (result ?? false) || (notifResult ?? false);
  }

  Future<void> scheduleNextNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final bool notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;

    if (!notificationsEnabled) {
      await cancelAllNotifications();
      return;
    }

    await cancelAllNotifications(); // Clear any existing to avoid spam

    // Calculate a random time between 2 to 6 hours from now
    final random = Random();
    int randomHours = random.nextInt(5) + 2; // 2, 3, 4, 5, or 6
    
    tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(hours: randomHours));

    // Constrain to 9 AM - 9 PM
    if (scheduledDate.hour < 9) {
      // Too early, move to 9:30 AM today
      scheduledDate = tz.TZDateTime(tz.local, scheduledDate.year, scheduledDate.month, scheduledDate.day, 9, 30);
    } else if (scheduledDate.hour >= 21) {
      // Too late, move to 9:30 AM TOMORROW
      scheduledDate = tz.TZDateTime(tz.local, scheduledDate.year, scheduledDate.month, scheduledDate.day, 9, 30).add(const Duration(days: 1));
    }

    final String randomMessage = _baitMessages[random.nextInt(_baitMessages.length)];

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'daily_training_channel',
      'Daily Training Reminders',
      channelDescription: 'Reminds you to train your brain daily',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: 0,
      title: 'Schulte Table challenge!',
      body: randomMessage,
      scheduledDate: scheduledDate,
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
