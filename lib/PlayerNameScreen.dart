import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nim/StonesPilesScreen.dart';
import 'package:nim/appcontroller.dart';
import 'package:nim/steps.dart';

class PlayerNameScreen extends StatefulWidget {
  @override
  State<PlayerNameScreen> createState() => _PlayerNameScreenState();
}

class _PlayerNameScreenState extends State<PlayerNameScreen> {
  final AppController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(GameStepsDialog());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Name'), actions: [
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            Get.dialog(GameStepsDialog());
          },
        ),
      ]),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250, // Set width to control the size
                child: TextField(
                  controller: controller.player1Name,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Name',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 16), // Adjust font size
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250, // Set width to control the size
                child: DropdownButtonFormField<String>(
                  value: controller.selectedPlayer,
                  onChanged: (String? newValue) {
                    controller.selectedPlayer = newValue!;
                  },
                  items: <String>[
                    controller.player1Name.text,
                    controller.player2Name
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Choose Who Will Start Playing first',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 16), // Adjust font size
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.currentPlayer =
                      (controller.selectedPlayer == controller.player2Name
                          ? 2
                          : 1);
                  controller.currentPlayerName = (controller.currentPlayer == 1
                      ? controller.player1Name.text
                      : controller.player2Name);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StonesPilesScreen(),
                    ),
                  );
                },
                child: const Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
