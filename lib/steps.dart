import 'package:flutter/material.dart';

class GameStepsDialog extends StatefulWidget {
  @override
  _GameStepsDialogState createState() => _GameStepsDialogState();
}

class _GameStepsDialogState extends State<GameStepsDialog> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(16),
      title: Text(
        isEnglish ? 'Game Introduction' : 'مقدمة اللعبة',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEnglish
                  ? 'Welcome to the Balls and Boxes game!'
                  : 'مرحبًا بك في لعبة الحجارة والصناديق!',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            Text(
              isEnglish
                  ? 'This is a simple yet challenging game where you take turns removing balls from boxes.'
                  : 'هذه لعبة بسيطة ولكنها تحديّة حيث تتناوب في إزالة الكرات من الصناديق.',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 20),
            Text(
              isEnglish ? 'Rules:' : 'القواعد:',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              isEnglish
                  ? '1. Each player takes turns removing one or more balls from a single box.'
                  : '1. يتناوب كل لاعب في إزالة كرة أو أكثر من صندوق واحد.',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5),
            Text(
              isEnglish
                  ? '2. The player who removes the last ball wins!'
                  : '2. اللاعب الذي يزيل الكرة الأخيرة يفوز!',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 20),
            Text(
              isEnglish ? 'Instructions:' : 'التعليمات:',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              isEnglish
                  ? 'To start the game, follow these steps:'
                  : 'لبدء اللعبة، اتبع الخطوات التالية:',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5),
            Text(
              isEnglish ? '1. Enter your name.' : '1. أدخل اسمك.',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5),
            Text(
              isEnglish
                  ? '2. Select who will start playing (developer or you).'
                  : '2. حدد من سيبدأ اللعب (المطور أو أنت).',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5),
            Text(
              isEnglish
                  ? '3. Specify the number of boxes.'
                  : '3. حدد عدد الصناديق.',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5),
            Text(
              isEnglish
                  ? '4. Specify the number of balls for each box.'
                  : '4. حدد عدد الكرات لكل صندوق.',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEnglish = !isEnglish;
                });
              },
              child:
                  Text(isEnglish ? 'Switch to Arabic' : 'تغيير إلى الإنجليزية'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
