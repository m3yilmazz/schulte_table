import 'dart:math';

import 'package:flutter/material.dart';
import 'main.dart';
import 'resultPage.dart';

class ClassicOriginalModePlayGround extends StatefulWidget {
  final ValueChanged<int> parentAction;

  const ClassicOriginalModePlayGround({required Key? key, required this.parentAction})
      : super(key: key);

  @override
  _ClassicOriginalModePlayGroundState createState() =>
      _ClassicOriginalModePlayGroundState();
}

class _ClassicOriginalModePlayGroundState extends State<ClassicOriginalModePlayGround> {
  _ClassicOriginalModePlayGroundState() {
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
  bool _hasBeenPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1),
      child: OutlinedButton(
        child: Text(
          this._number.toString(),
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))
        ),
        onPressed: () {
          if (sequenceControllerList.first == _number) {
            var sumOfAllExistingElementsInList = 0;
            timePassedToFindNumbers.forEach((element) {
              sumOfAllExistingElementsInList += element;
            });
            timePassedToFindNumbers.add(globalTimer - sumOfAllExistingElementsInList);
            sequenceControllerList.removeAt(0);
            if (_number + 1 < MAX_ELEMENT_NUMBER + 1) {
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
                          "bestTimeClassicOriginal",
                          "Classic Original Mode",
                          timePassedToFindNumbers,
                          "/classicOriginalMode",
                          false)));
            }
          }
        },
      ),
    );
  }
}