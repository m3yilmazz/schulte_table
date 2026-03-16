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
import 'package:schulte_table/ad_helper.dart';
import 'package:schulte_table/play_button.dart';
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
          "Classic Original",
          "/classicOriginalMode",
          bestTimeClassicOriginal,
          "Find the numbers in ascending order from 1 to 25.\n\nWatch out for the next number!\nYou only have 60 seconds!\n\nGood Luck!"),
      "/classicOriginalReverseModePlayButton": (context) => PlayButton(
          "Classic Original Reverse",
          "/classicOriginalReverseMode",
          bestTimeClassicOriginalReverse,
          "Find the numbers in descending order from 25 to 1.\n\nWatch out for the next number!\nYou only have 60 seconds!\n\nGood Luck!"),
      "/classicLightModePlayButton": (context) => PlayButton(
          "Classic Light",
          "/classicLightMode",
          bestTimeClassicLight,
          "Find the numbers in ascending order from 1 to 25.\nNumbers disappear after you tap them!\n\nYou only have 60 seconds!\n\nGood Luck!"),
      "/classicLightReverseModePlayButton": (context) => PlayButton(
          "Classic Light Reverse",
          "/classicLightReverseMode",
          bestTimeClassicLightReverse,
          "Find the numbers in descending order from 25 to 1.\nNumbers disappear after you tap them!\n\nYou only have 60 seconds!\n\nGood Luck!"),
      "/memoryModePlayButton": (context) => PlayButton(
          "Memory Mode",
          "/memoryMode",
          bestTimeMemory,
          "Numbers are visible for 3 seconds, then disappear!\nFind them in ascending order from 1 to 25.\nA misclick reveals them again briefly.\n\nGood Luck!"),
      "/reactionModePlayButton": (context) => PlayButton(
          "Reaction Mode",
          "/reactionMode",
          bestTimeReaction,
          "A red target cell will guide you to the next number.\nFind them in ascending order from 1 to 25.\nTest your reflexes!\n\nGood Luck!"),
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
        title: const Text("Schulte Table",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2)),
        backgroundColor: Colors.transparent, // Making AppBar transparent
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true, // Let the gradient flow behind the AppBar
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Select Game Mode",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    primary: false,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    children: <Widget>[
                      _buildGameModeButton(
                        context: context,
                        title: "Classic\nOriginal",
                        icon: Icons.grid_on_rounded,
                        route: "/classicOriginalModePlayButton",
                      ),
                      _buildGameModeButton(
                        context: context,
                        title: "Classic\nOriginal Reverse",
                        icon: Icons.keyboard_double_arrow_down_rounded,
                        route: "/classicOriginalReverseModePlayButton",
                      ),
                      _buildGameModeButton(
                        context: context,
                        title: "Classic\nLight",
                        icon: Icons.lightbulb_outline_rounded,
                        route: "/classicLightModePlayButton",
                      ),
                      _buildGameModeButton(
                        context: context,
                        title: "Classic\nLight Reverse",
                        icon: Icons.highlight_remove_rounded,
                        route: "/classicLightReverseModePlayButton",
                      ),
                      _buildGameModeButton(
                        context: context,
                        title: "Memory\nMode",
                        icon: Icons.psychology_rounded,
                        route: "/memoryModePlayButton",
                      ),
                      _buildGameModeButton(
                        context: context,
                        title: "Reaction\nMode",
                        icon: Icons.bolt_rounded,
                        route: "/reactionModePlayButton",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameModeButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String route,
  }) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        elevation: 6,
        shadowColor: Colors.deepPurple.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.all(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepPurple.shade50,
            radius: 30,
            child: Icon(
              icon,
              size: 32,
              color: Colors.deepPurpleAccent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
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
  listUsedForRandomAssignment.shuffle();
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
  late Stopwatch _stopwatch;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();

    bestTimeName = widget.bestTimeName;
    gameModeName = widget.gameModeName;
    list = widget.list;
    previousGameModeRoute = widget.previousGameModeRoute;
    isReverse = widget.isReverse;

    _stopwatch = Stopwatch()..start();

    _updateTimer = Timer.periodic(const Duration(milliseconds: 16), (callBack) {
      if (hasRoundFinished) {
        _stopwatch.stop();
        callBack.cancel();
        return;
      }

      globalTimer = _stopwatch.elapsedMilliseconds;
      setState(() {});

      if (!hasRoundFinished && globalTimer >= 60000) {
        _stopwatch.stop();
        callBack.cancel();
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
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${(globalTimer / 1000).toStringAsFixed(2)}s",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }
}

