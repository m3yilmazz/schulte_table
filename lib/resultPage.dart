import 'package:flutter/material.dart';

import 'main.dart';

class ResultPage extends StatefulWidget  {
  final String bestTimeName,
      previousGameModeRoute,
      gameModeName;
  final List<int> list;
  final bool isReverse;

  const ResultPage(this.bestTimeName, this.gameModeName, this.list, this.previousGameModeRoute, this.isReverse, {super.key});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>{
  @override
  void initState() {
    super.initState();
  }

  Widget printTimeSpentToFindNumbers() {
    var resultList = List<String>.empty(growable: true);
    int tempBestTime = 0;

    switch (widget.bestTimeName) {
      case "bestTimeClassicOriginal":
        {
          if (hasRoundFinished &&
              (bestTimeClassicOriginal == 0 ||
                  globalTimer < bestTimeClassicOriginal)) {
            bestTimeClassicOriginal = globalTimer;
          }
          tempBestTime = bestTimeClassicOriginal;
        }
        break;
    }

    resultList.add("Total Time: ${globalTimer / 1000} second(s)");
    resultList.add("Best Time: ${tempBestTime / 1000} second(s)");

    if (widget.isReverse) {
      for (int i = 0; i < MAX_ELEMENT_NUMBER; i++) {
        resultList.add("${MAX_ELEMENT_NUMBER - i}: ${widget.list[i] / 1000}");
      }
    } else {
      for (int i = 0; i < MAX_ELEMENT_NUMBER; i++) {
        resultList.add("${i + 1}: ${widget.list[i] / 1000}");
      }
    }

    return Flexible(
        child: Center(
            child: ListView(
                children: List.generate(
                    resultList.length,
                        (index) => Text(resultList[index],
                        textAlign: TextAlign.center)))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName("/"))),
        title: Text(
          "${widget.gameModeName} Results",
          style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
              onPressed: () =>
                  Navigator.pushNamed(context, widget.previousGameModeRoute),
              child: const Text("Play Again!", style: TextStyle(color: Colors.white))),
            Container(
                child:
                printTimeSpentToFindNumbers())
          ],
        ),
      ),
    );
  }
}