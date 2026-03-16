import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';
import 'result_page.dart';

class MemoryModePlayGround extends StatefulWidget {
  final ValueChanged<int> parentAction;
  const MemoryModePlayGround({required super.key, required this.parentAction});
  @override
  State<MemoryModePlayGround> createState() => _MemoryModePlayGroundState();
}

class _MemoryModePlayGroundState extends State<MemoryModePlayGround> {
  _MemoryModePlayGroundState() {
    _number = listUsedForRandomAssignment.removeLast();
  }

  int _number = 0;
  bool _hasBeenPressed = false,
      _hasBeenMisclicked = true,
      allButtonsLocked = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _hasBeenMisclicked = false;
          allButtonsLocked = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Visibility(
      visible: !_hasBeenPressed,
      child: Container(
        margin: const EdgeInsets.all(2),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: (_hasBeenMisclicked && !allButtonsLocked) 
                ? Colors.orange 
                : Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            if(!allButtonsLocked){
              if(sequenceControllerList.isNotEmpty && sequenceControllerList.first == _number) {
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
                  _hasBeenPressed = true;
                });
                if (sequenceControllerList.isEmpty) {
                  hasRoundFinished = true;
                  timePassedToFindNumbers.removeAt(0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultPage("bestTimeMemory", "Memory Mode", timePassedToFindNumbers, "/memoryMode", false)));
                }
              }
              else {
                setState(() {
                  _hasBeenMisclicked = true;
                });
                Timer(const Duration(seconds: 1), () {
                  setState(() {
                    _hasBeenMisclicked = false;
                  });
                });
              }
            }
          },
          child: Visibility(
            visible: _hasBeenMisclicked,
            child: Text(
              _number.toString(),
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 26.0, 
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MemoryMode extends StatefulWidget {
  const MemoryMode({super.key});

  @override
  State<StatefulWidget> createState() => MemoryModeState();
}

class MemoryModeState extends State<MemoryMode> {
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName("/")),
        ),
        title: const Text("Memory Mode",
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
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.deepPurpleAccent, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            "Find: #$internalNumberTracker",
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
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.deepPurpleAccent, size: 28),
                          const SizedBox(width: 8),
                          TimerManagement(
                            "bestTimeMemory",
                            "Memory Mode",
                            timePassedToFindNumbers,
                            "/memoryMode",
                            false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  crossAxisCount: 5,
                  children: List.generate(
                      maxElementNumber,
                      (index) => MemoryModePlayGround(
                          key: widget.key,
                          parentAction: updateInternalNumberTracker))),
            ),
          ]),
        ),
      ),
    );
  }
}
