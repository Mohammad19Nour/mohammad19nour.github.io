import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nim/Pile_widget.dart';
import 'package:nim/appcontroller.dart';
import 'package:nim/custome_dialog.dart';

class StonesPilesScreen extends StatefulWidget {
  StonesPilesScreen({super.key});

  @override
  State<StonesPilesScreen> createState() => _StonesPilesScreenState();
}

class _StonesPilesScreenState extends State<StonesPilesScreen> {
  final AppController controller = Get.find();

  final GlobalKey<FormFieldState> _formKey = GlobalKey<FormFieldState>();

  @override
  void dispose() {
    // Perform clean-up operations here
    print('Widget disposed');
    controller.resetGame(destroyed: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.sizeOf(context);

    return GetBuilder<AppController>(builder: (cc) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Balls Boxes'),
        ),
        body: Column(
          children: [
            Container(
              height: 500,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${controller.currentPlayerName}\'s turn',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screen.width * 0.017,
                              color: controller.currentPlayer == 1
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customButton('Set Number of Boxes', context, true),
                          const SizedBox(width: 20),
                          customButton('Set Number of stones for each Box',
                              context, false),
                          const SizedBox(width: 20),
                          startGameButton(screen),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            for (int i = 0;
                                i < (controller.numberOfPiles + 4) / 5;
                                i++)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    for (int j = i * 5;
                                        j <
                                            min(controller.numberOfPiles,
                                                (i + 1) * 5);
                                        j++)
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: PileWidget(
                                          pileNumber: j,
                                          stoneCount: controller.stoneCounts[j],
                                          onRemoveStone: (stonesToRemove) =>
                                              controller.removeStones(
                                                  j, stonesToRemove),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            //  Container(child: Text("$pile $numb"))
          ],
        ),
      );
    });
  }

  String? validator(String? val) {
    if (val == null) {
      return "Please enter a valid value";
    }
    var parsedValue = int.tryParse(val);
    if (parsedValue == null || parsedValue == 0 || parsedValue > 35) {
      return "Value must be a number between 1 and 35";
    }
    return null;
  }

  Widget startGameButton(screen) {
    return ElevatedButton(
      onPressed: controller.isSet()
          ? () {
              if (controller.started) {
                controller.resetGame();
              } else {
                controller.startGame();
                if (controller.currentPlayer == 2) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(
                        title: "It\'s ${controller.currentPlayerName} turn",
                        content:
                            "${controller.currentPlayerName} will kill you",
                        icon: Icons.info_outline,
                        iconColor: Colors.blue,
                      );
                    },
                  ).then((value) {
                    controller.removeStones(1, 1);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                          title: "Now it's your turn",
                          content:
                              "${controller.currentPlayerName} removed ${controller.developerChosenStones} balls from box number ${controller.developerChosenPile}",
                          icon: Icons.info_outline, // Optional icon
                          iconColor: Colors.blue, // Optional icon color
                        );
                      },
                    ).then((value) {
                      if (controller.numOfFilled() == 0)
                        Get.dialog(CustomDialog(
                            title: "Congratulations :)",
                            content:
                                "${controller.currentPlayerName} wins the game"));
                      else
                        controller.updateTurn();
                    });
                  });
                }
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        primary: Colors.green, // Background color
        onPrimary: Colors.white, // Text color
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
      ),
      child: Text(
        controller.started ? "Reset" : 'Start Game',
        style: TextStyle(
          fontSize: screen.width * 0.018,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget customButton(String title, BuildContext context, bool isPiles) {
    var screen = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: controller.started
          ? null
          : () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  List<Widget> formFields = [];
                  if (isPiles) {
                    formFields.add(
                      Container(
                        width: screen.width * 0.2,
                        child: TextFormField(
                          key: _formKey,
                          keyboardType: TextInputType.number,
                          validator: validator,
                          onChanged: (val) {
                            if (_formKey.currentState!.validate()) {
                              controller.updateNumberOfPiles(int.parse(val));
                            }
                          },
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              controller.updateNumberOfPiles(int.parse(value));
                            }
                          },
                        ),
                      ),
                    );
                  } else {
                    for (int i = 0; i < controller.numberOfPiles; i++) {
                      formFields.add(TextFormField(
                        key: controller.formKeys[i],
                        controller: controller.controllers[i],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Box ${i + 1}',
                        ),
                        validator: validator,
                      ));
                    }
                  }

                  return AlertDialog(
                    title: Text(
                      title,
                      style: TextStyle(fontSize: screen.width * 0.018),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...formFields,
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            bool ok = true;

                            if (!isPiles) {
                              for (int j = 0;
                                  j < controller.numberOfPiles;
                                  j++) {
                                ok &= controller.formKeys[j].currentState!
                                    .validate();
                              }
                              if (!ok) return;
                              controller.updateStoneCount();
                            } else {
                              if (_formKey.currentState!.validate()) {
                                controller.updateNumberOfPiles(
                                    controller.numberOfPiles);
                              } else {
                                return;
                              }
                            }
                            Navigator.pop(context);
                          },
                          child: const Text('Update'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // Background color
                            onPrimary: Colors.white, // Text color
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5.0,
                          ),
                        )
                      ],
                    ),
                    backgroundColor:
                        Colors.white, // Background color of the dialog
                  );
                },
              );
            },
      child: Text(
        title,
        style: TextStyle(fontSize: screen.width * 0.013, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // Background color
        onPrimary: Colors.white, // Text color
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
      ),
    );
  }
}
