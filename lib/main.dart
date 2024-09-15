import 'dart:async';
import 'package:flutter/material.dart';

import 'package:schulte_table/classicOriginalMode.dart';
import 'package:schulte_table/privacyPolicy.dart';
import 'package:schulte_table/resultPage.dart';

const int MAX_ELEMENT_NUMBER = 25;

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

void main() {
  listMaker();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (context) => HomeRoute(),
      "/classicOriginalModePlayButton": (context) => PlayButton(
          "Classic Original Mode",
          "/classicOriginalMode",
          bestTimeClassicOriginal),
      "/classicOriginalMode": (context) => ClassicOriginalMode(),
      "/privacyPolicy": (context) => const PrivacyPolicy(),
    },
  ));
}

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Schulte Table", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: 2,
        children: <Widget>[
          ElevatedButton(
            child: const Text("Classic Original",
                style: TextStyle(color: Colors.white)),
            onPressed: () =>
                Navigator.pushNamed(context, "/classicOriginalModePlayButton"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                )),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                  'Menu',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25)),
            ),
            ListTile(
              title: const Text('Game'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context); // Close the drawer.
                Navigator.pushNamed(context, "/privacyPolicy"); // Navigate to Privacy Policy widget.
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PlayButton extends StatefulWidget {
  late String gameModeName, routeName;
  late int bestTime;

  PlayButton(String gameModeName, String routeName, int bestTime) {
    this.gameModeName = gameModeName;
    this.routeName = routeName;
    this.bestTime = bestTime;
  }

  @override
  State<StatefulWidget> createState() {
    return new PlayButtonState(
        this.gameModeName,
        this.routeName,
        this.bestTime);
  }
}

class PlayButtonState extends State<PlayButton> {
  late String gameModeName, routeName;
  late int bestTime;

  PlayButtonState(String gameModeName, String routeName, int bestTime) {
    this.gameModeName = gameModeName;
    this.routeName = routeName;
    this.bestTime = bestTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName("/"))),
        title:
            Text("Play $gameModeName", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Best Time: ${this.bestTime / 1000} second(s)"),
            ElevatedButton(
              child: const Text("Play!", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  textStyle: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pushNamed(context, routeName),
            ),
          ],
        ),
      ),
    );
  }
}

class ClassicOriginalMode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return new ClassicOriginalModeState();
  }
}

class ClassicOriginalModeState extends State<ClassicOriginalMode> {
  int internalNumberTracker = 1;

  updateInternalNumberTracker(int nextNumber) {
    setState(() {
      internalNumberTracker = nextNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: Text("Classic Original Mode",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Number #: $internalNumberTracker")),
            Container(
                padding: EdgeInsets.all(10),
                child: Text("Mode: Classic Original")),
            Container(
                width: 100,
                padding: EdgeInsets.all(10),
                child: TimerManagement(
                    "bestTimeClassicOriginal",
                    "Classic Original Mode",
                    timePassedToFindNumbers,
                    "/classicOriginalMode",
                    false)),
          ],
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  MAX_ELEMENT_NUMBER,
                  (index) => ClassicOriginalModePlayGround(
                      key: this.widget.key,
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

void listMaker() {
  listUsedForRandomAssignment.clear();
  sequenceControllerList.clear();
  for (int i = 0; i < MAX_ELEMENT_NUMBER; i++) {
    listUsedForRandomAssignment.add(i + 1);
    sequenceControllerList.add(i + 1);
  }
}

class TimerManagement extends StatefulWidget {
  late String bestTimeName;
  late List<int> list;
  late String previousGameModeRoute, gameModeName;
  late bool isReverse;

  TimerManagement(String bestTimeName, String gameModeName, List<int> list,
      String previousGameModeRoute, bool isReverse) {
    this.bestTimeName = bestTimeName;
    this.gameModeName = gameModeName;
    this.list = list;
    this.previousGameModeRoute = previousGameModeRoute;
    this.isReverse = isReverse;
  }

  @override
  _TimerManagementState createState() => _TimerManagementState(
      bestTimeName, gameModeName, list, previousGameModeRoute, isReverse);
}

class _TimerManagementState extends State<TimerManagement> {
  late String bestTimeName;
  late List<int> list;
  late String previousGameModeRoute, gameModeName;
  late bool isReverse;

  _TimerManagementState(String bestTimeName, String gameModeName,
      List<int> list, String previousGameModeRoute, bool isReverse) {
    bestTimeName = bestTimeName;
    gameModeName = gameModeName;
    list = list;
    previousGameModeRoute = previousGameModeRoute;
    isReverse = isReverse;
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 1), (callBack) {
      setState(() {
        if (hasRoundFinished) {
          callBack.cancel();
        }
        globalTimer += 1;
        if (!hasRoundFinished && globalTimer == 60000) {
          for (int i = list.length; i < MAX_ELEMENT_NUMBER; i++) {
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
    return Text((globalTimer / 1000).toStringAsFixed(3));
  }
}
