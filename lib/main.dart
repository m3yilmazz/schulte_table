import 'dart:async';
import 'package:flutter/material.dart';

import 'package:schulte_table/classic_original_mode.dart';
import 'package:schulte_table/classic_original_reverse_mode.dart';
import 'package:schulte_table/classic_light_mode.dart';
import 'package:schulte_table/classic_light_reverse_mode.dart';
import 'package:schulte_table/memory_mode.dart';
import 'package:schulte_table/reaction_mode.dart';
import 'package:schulte_table/privacy_policy.dart';
import 'package:schulte_table/result_page.dart';
import 'package:schulte_table/settings.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:schulte_table/app_open_ad_manager.dart';
import 'package:schulte_table/notification_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

const int maxElementNumber = 25;

List<int> timePassedToFindNumbers = [0];
List<int> listUsedForRandomAssignment = [];
List<int> sequenceControllerList = [];
int globalTimer = 0;
int bestTimeReaction = 0,
    bestTimeClassicLight = 0,
    bestTimeClassicLightReverse = 0,
    bestTimeClassicOriginal = 0,
    bestTimeClassicOriginalReverse = 0,
    bestTimeMemory = 0;

bool hasRoundFinished = false;

AppOpenAdManager appOpenAdManager = AppOpenAdManager();
late AppLifecycleListener appLifecycleListener;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  appOpenAdManager.loadAd();
  
  await NotificationService().init();
  await NotificationService().requestPermissions();
  await NotificationService().scheduleNextNotification();

  appLifecycleListener = AppLifecycleListener(
    onStateChange: (state) {
      if (state == AppLifecycleState.resumed) {
        appOpenAdManager.showAdIfAvailable();
      }
    },
  );

  // Attempt to show the Ad immediately on cold boot after a brief delay 
  // to allow the Google servers time to fetch the payload.
  Future.delayed(const Duration(seconds: 3), () {
    appOpenAdManager.showAdIfAvailable();
  });

  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  bestTimeClassicOriginal = prefs.getInt('bestTimeClassicOriginal') ?? 0;
  bestTimeClassicOriginalReverse = prefs.getInt('bestTimeClassicOriginalReverse') ?? 0;
  bestTimeClassicLight = prefs.getInt('bestTimeClassicLight') ?? 0;
  bestTimeClassicLightReverse = prefs.getInt('bestTimeClassicLightReverse') ?? 0;
  bestTimeMemory = prefs.getInt('bestTimeMemory') ?? 0;
  bestTimeReaction = prefs.getInt('bestTimeReaction') ?? 0;

  listMaker();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (context) => const HomeRoute(),
      "/settings": (context) => const Settings(),
      "/classicOriginalModePlayButton": (context) => PlayButton(
          "Classic Original Mode",
          "/classicOriginalMode",
          bestTimeClassicOriginal),
      "/classicOriginalReverseModePlayButton": (context) => PlayButton(
          "Classic Original Reverse Mode",
          "/classicOriginalReverseMode",
          bestTimeClassicOriginalReverse),
      "/classicLightModePlayButton": (context) => PlayButton(
          "Classic Light Mode",
          "/classicLightMode",
          bestTimeClassicLight),
      "/classicLightReverseModePlayButton": (context) => PlayButton(
          "Classic Light Reverse Mode",
          "/classicLightReverseMode",
          bestTimeClassicLightReverse),
      "/memoryModePlayButton": (context) => PlayButton(
          "Memory Mode",
          "/memoryMode",
          bestTimeMemory),
      "/reactionModePlayButton": (context) => PlayButton(
          "Reaction Mode",
          "/reactionMode",
          bestTimeReaction),
      "/classicOriginalMode": (context) => const ClassicOriginalMode(),
      "/classicOriginalReverseMode": (context) => const ClassicOriginalReverseMode(),
      "/classicLightMode": (context) => const ClassicLightMode(),
      "/classicLightReverseMode": (context) => const ClassicLightReverseMode(),
      "/memoryMode": (context) => const MemoryMode(),
      "/reactionMode": (context) => const ReactionMode(),
      "/privacyPolicy": (context) => const PrivacyPolicy(),
    },
  ));
}

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Schulte Table", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),
        ],
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: 2,
        children: <Widget>[
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, "/classicOriginalModePlayButton"),
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.deepPurpleAccent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                )),
            child: const Text(
              "Classic Original",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
                context, "/classicOriginalReverseModePlayButton"),
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.deepPurpleAccent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                )),
            child: const Text("Classic Original Reverse",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
                context, "/classicLightModePlayButton"),
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.deepPurpleAccent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                )),
            child: const Text("Classic Light",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
                context, "/classicLightReverseModePlayButton"),
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.deepPurpleAccent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                )),
            child: const Text("Classic Light Reverse",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
                context, "/memoryModePlayButton"),
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.deepPurpleAccent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                )),
            child: const Text("Memory",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
                context, "/reactionModePlayButton"),
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.deepPurpleAccent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                )),
            child: const Text("Reaction",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}

void listMaker() {
  listUsedForRandomAssignment.clear();
  sequenceControllerList.clear();
  for (int i = 0; i < maxElementNumber; i++) {
    listUsedForRandomAssignment.add(i + 1);
    sequenceControllerList.add(i + 1);
  }
}

class TimerManagement extends StatefulWidget {
  final String bestTimeName, previousGameModeRoute, gameModeName;
  final List<int> list;
  final bool isReverse;

  const TimerManagement(this.bestTimeName, this.gameModeName, this.list,
      this.previousGameModeRoute, this.isReverse, {super.key});

  @override
  State<TimerManagement> createState() => _TimerManagementState();
}

class _TimerManagementState extends State<TimerManagement> {
  late String bestTimeName, previousGameModeRoute, gameModeName;
  late List<int> list = List.empty(growable: true);
  late bool isReverse;

  @override
  void initState() {
    super.initState();

    bestTimeName = widget.bestTimeName;
    gameModeName = widget.gameModeName;
    list = widget.list;
    previousGameModeRoute = widget.previousGameModeRoute;
    isReverse = widget.isReverse;

    Timer.periodic(const Duration(milliseconds: 1), (callBack) {
      setState(() {
        if (hasRoundFinished) {
          callBack.cancel();
        }
        globalTimer += 1;
        if (!hasRoundFinished && globalTimer == 60000) {
          for (int i = list.length; i < maxElementNumber; i++) {
            list.add(0);
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultPage(bestTimeName, gameModeName,
                      list, previousGameModeRoute, isReverse)));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${(globalTimer / 1000).toStringAsFixed(3)}s",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }
}

class PlayButton extends StatefulWidget {
  final String gameModeName, routeName;
  final int bestTime;

  const PlayButton(this.gameModeName, this.routeName, this.bestTime, {super.key});

  @override
  State<StatefulWidget> createState() => PlayButtonState();
}

class PlayButtonState extends State<PlayButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName("/"))),
        title: Text("Play ${widget.gameModeName}",
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.info_outline,
                                color: Colors.deepPurpleAccent, size: 28),
                            const SizedBox(width: 10),
                            Text(
                              "How to Play",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Find the numbers in the order placed at the upper left corner.\n\n"
                          "Watch out for the next number!\n"
                          "You only have 60 seconds!\n\n"
                          "Good Luck!",
                          style: TextStyle(
                              fontSize: 16, height: 1.5, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.deepPurple.shade50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.emoji_events,
                            color: Colors.orange, size: 30),
                        const SizedBox(width: 12),
                        Text(
                          "Best Time: ${widget.bestTime ~/ 1000}s",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      iconColor: Colors.white,
                      elevation: 8,
                      shadowColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow, size: 30),
                    label: const Text(
                      "PLAY",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, widget.routeName),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

