import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schulte_table/banner_ad_manager.dart';
import 'package:schulte_table/notification_service.dart';

import 'main.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _adHelper = BannerAdHelper();
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _adHelper.loadAd(onAdLoaded: () {
      if (mounted) setState(() {});
    });
    _loadNotificationPreference();
  }

  @override
  void dispose() {
    _adHelper.dispose();
    super.dispose();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });

    if (value) {
      await NotificationService().requestPermissions();
      await NotificationService().scheduleNextNotification();
    } else {
      await NotificationService().cancelAllNotifications();
    }
  }



  // Wipes all 6 specific best times from disk + global RAM
  Future<void> _resetBestTimes(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('bestTimeClassicOriginal');
    await prefs.remove('bestTimeClassicOriginalReverse');
    await prefs.remove('bestTimeClassicLight');
    await prefs.remove('bestTimeClassicLightReverse');
    await prefs.remove('bestTimeMemory');
    await prefs.remove('bestTimeReaction');

    bestTimeClassicOriginal = 0;
    bestTimeClassicOriginalReverse = 0;
    bestTimeClassicLight = 0;
    bestTimeClassicLightReverse = 0;
    bestTimeMemory = 0;
    bestTimeReaction = 0;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'All Best Times have been successfully reset!',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.deepPurple,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // Pops a confirmation dialogue before wiping
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.redAccent, size: 28),
              SizedBox(width: 10),
              Text('Reset Progress'),
            ],
          ),
          content: const Text(
            'Are you sure you want to permanently delete all your Best Time records? This action cannot be undone.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Delete',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
                _resetBestTimes(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: const Text("Settings",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 8.0, top: 10.0),
                child: Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 5),
                  title: const Text(
                    'Daily Reminders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  subtitle: const Text(
                    'Receive occasional notifications to train your brain.',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: _notificationsEnabled,
                  activeTrackColor: Colors.deepPurple.shade100,
                  activeThumbColor: Colors.purpleAccent,
                  onChanged: _toggleNotifications,
                  secondary: const Icon(
                    Icons.notifications_active_rounded,
                    color: Colors.purpleAccent,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 8.0, top: 10.0),
                child: Text(
                  "Data Management",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_forever,
                        color: Colors.redAccent, size: 28),
                  ),
                  title: const Text(
                    "Reset Best Times",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  subtitle: const Text(
                    "Permanently wipe all your high scores.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 18, color: Colors.grey),
                  onTap: () => _showConfirmationDialog(context),
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  "Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.privacy_tip,
                        color: Colors.blueAccent, size: 28),
                  ),
                  title: const Text(
                    "Privacy Policy",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  subtitle: const Text(
                    "Read our data and privacy agreements.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 18, color: Colors.grey),
                  onTap: () => Navigator.pushNamed(context, "/privacyPolicy"),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
      bottomNavigationBar: _adHelper.buildBannerWidget(),
    );
  }
}
