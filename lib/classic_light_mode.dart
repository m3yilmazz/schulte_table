import 'dart:math';

import 'package:flutter/material.dart';
import 'main.dart';
import 'result_page.dart';

class ClassicLightModePlayGround extends StatefulWidget {
  final ValueChanged<int> parentAction;
  const ClassicLightModePlayGround({required super.key, required this.parentAction});
  @override
  State<ClassicLightModePlayGround> createState() =>
      _ClassicLightModePlayGroundState();
}

class _ClassicLightModePlayGroundState
    extends State<ClassicLightModePlayGround> {
  _ClassicLightModePlayGroundState() {
    var random = Random();
    do {
      var checkIsValidInList = random.nextInt(maxElementNumber) + 1;
      if (listUsedForRandomAssignment.contains(checkIsValidInList)) {
        _number = checkIsValidInList;
        listUsedForRandomAssignment.remove(checkIsValidInList);
        break;
      }
    } while (true);
  }

  int _number = 0;
  bool _hasBeenPressed = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _hasBeenPressed ? false : true,
      child: Container(
        margin: const EdgeInsets.all(1),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            overlayColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: () {
            if (sequenceControllerList.first == _number) {
              var sumOfAllExistingElementsInList = 0;
              for (var element in timePassedToFindNumbers) {
                sumOfAllExistingElementsInList += element;
              }
              timePassedToFindNumbers
                  .add(globalTimer - sumOfAllExistingElementsInList);
              sequenceControllerList.removeAt(0);
              if (_number + 1 < maxElementNumber + 1) {
                widget.parentAction(_number + 1);
              }

              setState(() {
                _hasBeenPressed = !_hasBeenPressed;
              });
              if (sequenceControllerList.isEmpty) {
                hasRoundFinished = true;
                timePassedToFindNumbers.removeAt(0);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResultPage(
                            "bestTimeClassicLight",
                            "Classic Light Mode",
                            timePassedToFindNumbers,
                            "/classicLightMode",
                            false)));
              }
            }
          },
          child: Text(
            _number.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}

class ClassicLightMode extends StatefulWidget {
  const ClassicLightMode({super.key});

  @override
  State<StatefulWidget> createState() => ClassicLightModeState();
}

class ClassicLightModeState extends State<ClassicLightMode> {
  int internalNumberTracker = 1;

  @override
  void initState() {
    super.initState();
    timePassedToFindNumbers = [0];
    globalTimer = 0;
    hasRoundFinished = false;
    listMaker();
  }

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
        title: const Text("Classic Light Mode",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.deepPurpleAccent),
                    const SizedBox(width: 8),
                    Text(
                      "Find: #$internalNumberTracker",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.deepPurpleAccent),
                    const SizedBox(width: 8),
                    TimerManagement(
                      "bestTimeClassicLight",
                      "Classic Light Mode",
                      timePassedToFindNumbers,
                      "/classicLightMode",
                      false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(5),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              children: List.generate(
                  maxElementNumber,
                  (index) => ClassicLightModePlayGround(
                      key: widget.key,
                      parentAction: updateInternalNumberTracker))),
        ),
      ]),
    );
  }
}
