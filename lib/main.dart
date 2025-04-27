import 'dart:async';
import 'package:flutter/material.dart';

import 'package:schulte_table/classicOriginalMode.dart';
import 'package:schulte_table/classicOriginalReverseMode.dart';
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
      "/classicOriginalReverseModePlayButton": (context) => PlayButton(
          "Classic Original Reverse Mode",
          "/classicOriginalReverseMode",
          bestTimeClassicOriginalReverse),
      "/classicOriginalMode": (context) => ClassicOriginalMode(),
      "/classicOriginalReverseMode": (context) => ClassicOriginalReverseMode(),
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
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center),
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
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 25)),
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
                Navigator.pushNamed(context,
                    "/privacyPolicy"); // Navigate to Privacy Policy widget.
              },
            ),
          ],
        ),
      ),
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
  late String bestTimeName, previousGameModeRoute, gameModeName;
  late List<int> list = List.empty(growable: true);
  late bool isReverse;

  TimerManagement(this.bestTimeName, this.gameModeName, this.list,
      this.previousGameModeRoute, this.isReverse);

  @override
  _TimerManagementState createState() => _TimerManagementState();
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
    return Text("Time: " + (globalTimer / 1000).toStringAsFixed(3));
  }
}

class PlayButton extends StatefulWidget {
  late String gameModeName, routeName;
  late int bestTime;

  PlayButton(this.gameModeName, this.routeName, this.bestTime, {super.key});

  @override
  State<StatefulWidget> createState() {
    return new PlayButtonState(gameModeName, routeName, bestTime);
  }
}

class PlayButtonState extends State<PlayButton> {
  late String gameModeName, routeName;
  late int bestTime;

  PlayButtonState(this.gameModeName, this.routeName, this.bestTime);

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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        "How to Play: You need to find the numbers in the order which placed at the upper left corner. "
                        "Watch out for the next number! "
                        "Do not forget you got only 60 seconds! "
                        "Good Luck!",
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Best Time: ${this.bestTime / 1000} second(s)",
                        style: const TextStyle(
                            color: Colors.black, fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () => Navigator.pushNamed(context, routeName),
                      child: const Text("PLAY",
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
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
        title: const Text("Classic Original Mode",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Text("Find the Number #$internalNumberTracker")),
            Container(
                width: 110,
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
                      key: widget.key,
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}

class ClassicOriginalReverseMode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
    return new ClassicOriginalReverseModeState();
  }
}

class ClassicOriginalReverseModeState
    extends State<ClassicOriginalReverseMode> {
  int internalNumberTracker = 25;

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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: const Text("Classic Original Reverse Mode",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Find the Number #$internalNumberTracker",
                  style: const TextStyle(color: Colors.black, fontSize: 15.0),
                )),
            Container(
                width: 110,
                padding: const EdgeInsets.all(10),
                child: TimerManagement(
                    "bestTimeClassicOriginalReverse",
                    "Classic Original Reverse Mode",
                    timePassedToFindNumbers,
                    "/classicOriginalReverseMode",
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
                  (index) => ClassicOriginalReverseModePlayGround(
                      key: widget.key,
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}
