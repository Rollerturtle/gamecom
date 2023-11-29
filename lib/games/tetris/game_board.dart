import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'mino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gamecom/db/database_helper.dart';
import 'package:gamecom/game_menu.dart';

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final FreezedMino freezedMino = FreezedMino();
  final minoTypeList = <MType>[];
  Mino mino = Mino(MType.i);
  bool start = false;
  bool isPlaying = false;
  bool usedHardDrop = false;
  int count = 0;
  Future<void> mainLoop() async {
    if (start) return;
    generateMinoTypeList();
    start = true;
    isPlaying = true;
    mino = Mino(minoTypeList.removeAt(0));
    count = 0;
    while (isPlaying) {
      setState(() {});
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      if (!mino.move(const Point<int>(0, 1), freezedMino.data)) {
        freezedMino.add(mino.currentMino);
        count += freezedMino.delete();
        if (freezedMino.gameOver) {
          reset();
          setState(() {});
          return;
        }
        mino = Mino(minoTypeList.removeAt(0));
      }
    }
    reset();
    setState(() {});
  }

  Future<void> saveHighScore(int newScore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Dapatkan skor tertinggi yang saat ini tersimpan
    int currentHighScore = await HighScoreManager.getHighScore();

    // Jika skor baru lebih tinggi dari skor tertinggi yang tersimpan
    if (newScore > currentHighScore) {
      String playerName = await _showNameInputDialog() ??
          ''; // Jika nilai null, isi dengan string kosong
      if (playerName.isNotEmpty) {
        await DatabaseHelper().insertHighScoreTetris(playerName, newScore);
        await HighScoreManager.setHighScore(newScore);
      }
    }
  }

  Future<String?> _showNameInputDialog() async {
    TextEditingController _nameController = TextEditingController();
    return await showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter your name'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(_nameController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> reset() async {
    start = false;
    freezedMino.clear();

    int currentScore = count; // Calculate the current score

    int highScore = await HighScoreManager.getHighScore();
    if (currentScore > highScore) {
      // Show a dialog for the user to input their name
      String playerName = await _showNameInputDialog() ?? '';

      if (playerName.isNotEmpty) {
        // Update the high score in the database
        await DatabaseHelper().insertHighScoreTetris(playerName, currentScore);
        await HighScoreManager.setHighScore(currentScore);
      }
    }
  }

  void hardDrop() {
    setState(() {
      freezedMino.add(mino.futureMino(freezedMino.data));
      count += freezedMino.delete();
      mino = Mino(minoTypeList.removeAt(0));
    });
  }

  void generateMinoTypeList() {
    for (var index = 0; index < 1000; index++) {
      minoTypeList.addAll([
        MType.i,
        MType.t,
        MType.o,
        MType.s,
        MType.z,
        MType.j,
        MType.l
      ]..shuffle());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHight = MediaQuery.of(context).size.height;
    const scale = 4 / 5;
    final width = screenWidth * 2 < screenHight
        ? screenWidth * scale
        : (screenHight * scale) / 2;
    final size = Size(width, width * 2);
    final horizontalCenter = screenWidth / 2;
    final dragThreshold = width / 10;
    final flickThreshold = width / 10;
    var deltaLeft = 0.0;
    var deltaRight = 0.0;
    var deltaDown = 0.0;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => start ? setState(() => isPlaying = false) : mainLoop(),
        backgroundColor: start ? Colors.red : Colors.green,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.grey[300],
                width: width,
                height: width * 2,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: size,
                      painter: RenderMino(
                          mino:
                              mino == null ? <Point<int>>[] : mino.currentMino),
                    ),
                    CustomPaint(
                      size: size,
                      painter:
                          RenderMino(mino: freezedMino.data, color: Colors.red),
                    ),
                    CustomPaint(
                      size: size,
                      painter: RenderMino(
                        mino: mino == null
                            ? <Point<int>>[]
                            : mino.futureMino(freezedMino.data),
                        paintingStyle: PaintingStyle.stroke,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: width / 5,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    children: [
                      Text('Score: $count',
                          style: Theme.of(context).textTheme.headline3),
                      FutureBuilder<int>(
                        future: HighScoreManager.getHighScore(),
                        builder: (BuildContext context,
                            AsyncSnapshot<int> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            int highScore = snapshot.data ?? 0;
                            return Text('High Score: $highScore',
                                style: TextStyle(fontSize: 20));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            dragStartBehavior: DragStartBehavior.down,
            onPanDown: (_) {
              usedHardDrop = false;
              deltaDown = 0.0;
            },
            onTapUp: (details) {
              if (details.globalPosition.dx < horizontalCenter) {
                setState(() => mino.rotateCCW(freezedMino.data));
              } else {
                setState(() => mino.rotateCW(freezedMino.data));
              }
            },
            onPanUpdate: (details) {
              if (details.delta.dx > 0) {
                deltaRight += details.delta.dx;
                if (dragThreshold < deltaRight) {
                  setState(() =>
                      mino.move(const Point<int>(1, 0), freezedMino.data));
                  deltaRight = 0;
                }
              } else {
                deltaLeft += details.delta.dx.abs();
                if (dragThreshold < deltaLeft) {
                  setState(() =>
                      mino.move(const Point<int>(-1, 0), freezedMino.data));
                  deltaLeft = 0;
                }
              }
              if (details.delta.dy > 0) {
                deltaDown += details.delta.dy;
                if (deltaDown > dragThreshold && !usedHardDrop) {
                  setState(() =>
                      mino.move(const Point<int>(0, 1), freezedMino.data));
                  deltaDown = 0;
                }
              }
              if (details.delta.dy > flickThreshold && !usedHardDrop) {
                usedHardDrop = true;
                deltaDown = 0;
                hardDrop();
              }
            },
          ),
          isPlaying ? const SizedBox() : Container(color: Colors.transparent)
        ],
      ),
    );
  }
}

class HighScoreManager {
  static const String _highScoreKey = 'high_score';

  static Future<int> getHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  static Future<void> setHighScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, score);
  }
}
