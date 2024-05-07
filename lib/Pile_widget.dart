import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nim/appcontroller.dart';
import 'package:nim/custome_dialog.dart';

class PileWidget extends StatelessWidget {
  final int pileNumber;
  final int stoneCount;
  final bool Function(int) onRemoveStone;

  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  PileWidget({
    required this.pileNumber,
    required this.stoneCount,
    required this.onRemoveStone,
  });

  final AppController controllerr = Get.find();
  String valu = "0";

  @override
  Widget build(BuildContext context) {
    int numRows = (stoneCount / 5).ceil();
    int numColumns = 1;

    if (numRows != 0) numColumns = (stoneCount / numRows).ceil();

    // Define a list of colors for each pile
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
    ];

    // Select color for this pile based on its number
    Color color = colors[pileNumber % colors.length];

    // Check if the pile is empty
    bool isEmpty = stoneCount == 0;

    return Container(
      width: 150,
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isEmpty
            ? Colors.grey
            : color, // Set color to grey if the pile is empty
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Box ${pileNumber + 1}',
            style: TextStyle(
              color:
                  isEmpty ? Colors.black54 : Colors.white, // Adjust text color
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numColumns,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: stoneCount,
              itemBuilder: (context, index) {
                return Icon(
                  Icons.circle,
                  color: isEmpty
                      ? Colors.black54
                      : Colors.white, // Adjust stone color
                  size: 20,
                );
              },
            ),
          ),
          SizedBox(height: 5),
          Text(
            '$stoneCount',
            style: TextStyle(
              color:
                  isEmpty ? Colors.black54 : Colors.white, // Adjust text color
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: isEmpty || !controllerr.started
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              'Remove Balls from Box number ${pileNumber + 1}'),
                          content: Column(
                            children: [
                              TextFormField(
                                key: _key,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Number of Balls to Remove',
                                ),
                                validator: (val) {
                                  return validator(val, pileNumber);
                                },
                                onChanged: (va) {
                                  valu = va;
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  if (_key.currentState!.validate()) {
                                    onRemoveStone(int.parse(valu));
                                    Navigator.pop(context);
                                    if (controllerr.numOfFilled() == 0) {
                                      Get.dialog(CustomDialog(
                                          title: "Congratulations :)",
                                          content:
                                              "${controllerr.currentPlayerName} wins the game"));
                                    } else {
                                      controllerr.updateTurn();

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext contextt) {
                                          String content =
                                              "Your turn! Make a move that's so bold, it could end up in the hall of fame... or the hall of shame!";
                                          if (controllerr.currentPlayer == 2) {
                                            content =
                                                "Get ready to say goodbye! My next move is going to knock your socks off!";
                                            if (controllerr.numOfFilled() > 1) {
                                              content =
                                                  "Hold onto your hats! I'm about to make a move that will send you packing!";
                                            }
                                          }
                                          return CustomDialog(
                                            title:
                                                "It\'s ${controllerr.currentPlayerName} turn",
                                            content: content,
                                            icon: Icons
                                                .info_outline, // Optional icon
                                            iconColor: Colors
                                                .blue, // Optional icon color
                                          );
                                        },
                                      ).then((value) {
                                        if (controllerr.currentPlayer == 2) {
                                          controllerr.removeStones(1, 1);

                                          Get.dialog(CustomDialog(
                                                  title:
                                                      "I'll blow your brains out",
                                                  content:
                                                      "${controllerr.currentPlayerName} removed ${controllerr.developerChosenStones} balls from box number ${controllerr.developerChosenPile}"))
                                              .then((value) {
                                            if (controllerr.numOfFilled() ==
                                                0) {
                                              Get.dialog(CustomDialog(
                                                  title: "Congratulations :)",
                                                  content:
                                                      "${controllerr.currentPlayerName} wins the game"));
                                            } else {
                                              controllerr.updateTurn();
                                            }
                                          });
                                        }
                                      });
                                    }
                                  }
                                },
                                child: const Text('Remove'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green, // Background color
                                  onPrimary: Colors.white, // Text color
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0, vertical: 20.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5.0,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
            child: const Text('Remove Balls'),
          ),
        ],
      ),
    );
  }

  String? validator(String? val, int idx) {
    if (val == null) {
      return "Please enter a valid value";
    }
    var parsedValue = int.tryParse(val);
    if (parsedValue == null ||
        parsedValue <= 0 ||
        parsedValue > controllerr.stoneCounts[idx]) {
      return "Value must be a number between 1 and ${controllerr.stoneCounts[idx]}";
    }
    return null;
  }
}
