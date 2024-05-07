import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nim/custome_dialog.dart';

class AppController extends GetxController {
  bool started = false;
  bool finished = false;
  TextEditingController player1Name = TextEditingController(text: "Player 1");
  final String player2Name = "Developer";
  String currentPlayerName = "Developer";
  int currentPlayer = 2;
  String selectedPlayer = "Developer";
  List<int> stoneCounts = [];
  List<TextEditingController> controllers = [];
  int numberOfPiles = 0;
  int developerChosenPile = 0;
  int developerChosenStones = 0;

  List<GlobalKey<FormFieldState>> formKeys =
      List.generate(1, (index) => GlobalKey<FormFieldState>());
  @override
  void initState() {
    selectedPlayer = player2Name;
    print("GGG00");
  }

  void updateNumberOfPiles(int newNumberOfPiles) {
    print(numberOfPiles);
    numberOfPiles = newNumberOfPiles;
    stoneCounts = List<int>.filled(numberOfPiles, 0);
    controllers = List.generate(
      numberOfPiles + 1,
      (index) => TextEditingController(),
    );
    formKeys = List.generate(
        numberOfPiles + 1, (index) => GlobalKey<FormFieldState>());
    update();
  }

  void updateStoneCount() {
    try {
      for (int j = 0; j < numberOfPiles; ++j) {
        stoneCounts[j] = int.parse(controllers[j].text);
      }
      update();
      // ignore: empty_catches
    } catch (e) {}
  }

  bool removeStones(int index, int stonesToRemove) {
    if (currentPlayer == 1 &&
        (stoneCounts[index] < stonesToRemove || stonesToRemove <= 0)) {
      return false;
    }

    if (currentPlayer == 2) {
      int xr = 0;
      index = 0;
      stonesToRemove = 0;

      for (int j = 0; j < stoneCounts.length; j++) {
        xr ^= stoneCounts[j];
      }

      for (int j = 0; j < stoneCounts.length; j++) {
        int curXr = (xr ^ stoneCounts[j]);
        if (stoneCounts[j] >= curXr) {
          index = j;
          stonesToRemove = stoneCounts[j] - curXr;
        }
      }

      if (stonesToRemove == 0) {
        for (int j = 0; j < stoneCounts.length; j++) {
          if (stoneCounts[j] > 0) {
            index = j;
            stonesToRemove = stoneCounts[j];
          }
        }
      }
      developerChosenPile = index + 1;
      developerChosenStones = stonesToRemove;
    }

    if (stoneCounts[index] >= stonesToRemove && stonesToRemove > 0) {
      stoneCounts[index] -= stonesToRemove;
    }

    update();
    return true;
  }

  int numOfFilled() {
    int x = 0;
    for (int j = 0; j < numberOfPiles; j++) {
      if (stoneCounts[j] > 0) ++x;
    }
    return x;
  }

  void updateTurn() {
    currentPlayer = 3 ^ currentPlayer;

    currentPlayerName = currentPlayer == 1 ? player1Name.text : player2Name;
    // if (currentPlayer == 2) removeStones(1, 1);
    update();
  }

  bool isSet() {
    if (started) return true;
    return !(stoneCounts.any((element) => element == 0) ||
        (numberOfPiles == 0));
  }

  void startGame() {
    started = true;
    update();
  }

  void resetGame({bool destroyed = false}) {
    started = false;
    //   stoneCounts.clear();
    formKeys.clear();
    controllers.clear();
    currentPlayer = (selectedPlayer == player2Name ? 2 : 1);
    currentPlayerName = currentPlayerName == 1 ? player1Name.text : player2Name;
    // selectedPlayer = player2Name;
    // player1Name.text = "Player 1";
    numberOfPiles = 0;
    developerChosenPile = 0;
    developerChosenStones = 0;
    finished = false;
    if (!destroyed) update();
  }
}
