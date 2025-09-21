import 'dart:math';

import 'package:flutter/material.dart';
import 'main.dart';
import 'resultPage.dart';

class ClassicOriginalReverseModePlayGround extends StatefulWidget {
  final ValueChanged<int> parentAction;

  const ClassicOriginalReverseModePlayGround(
      {required super.key, required this.parentAction});

  @override
  _ClassicOriginalReverseModePlayGroundState createState() =>
      _ClassicOriginalReverseModePlayGroundState();
}

class _ClassicOriginalReverseModePlayGroundState
    extends State<ClassicOriginalReverseModePlayGround> {
  _ClassicOriginalReverseModePlayGroundState() {
    var random = Random();
    do {
      var checkIsValidInList = random.nextInt(MAX_ELEMENT_NUMBER) + 1;
      if (listUsedForRandomAssignment.contains(checkIsValidInList)) {
        _number = checkIsValidInList;
        listUsedForRandomAssignment.remove(checkIsValidInList);
        break;
      }
    } while (true);
  }

  int _number = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      child: OutlinedButton(
        onPressed: () {
          if (sequenceControllerList.last == _number) {
            var sumOfAllExistingElementsInList = 0;

            for (var element in timePassedToFindNumbers) {
              sumOfAllExistingElementsInList += element;
            }
            timePassedToFindNumbers
                .add(globalTimer - sumOfAllExistingElementsInList);
            sequenceControllerList.removeLast();

            if (0 < _number - 1) {
              widget.parentAction(_number - 1);
            }

            if (sequenceControllerList.isEmpty) {
              hasRoundFinished = true;
              timePassedToFindNumbers.removeAt(0);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultPage(
                          "bestTimeClassicOriginalReverse",
                          "Classic Original Reverse Mode",
                          timePassedToFindNumbers,
                          "/classicOriginalReverseMode",
                          true)));
            }
          }
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          overlayColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          _number.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),
    );
  }
}
