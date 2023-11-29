import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamecom/game_menu.dart';
import 'package:gamecom/db/database_helper.dart';

enum Direction { up, down, left, right }

Timer? gameTimer;

class SnakeGame extends StatefulWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  List<int> snakePosition = [24, 44, 64];
  int foodLocation = Random().nextInt(700);
  bool start = false;
  Direction direction = Direction.down;
  List<int> totalSpot = List.generate(760, (index) => index);

  startGame() {
    start = true;
    snakePosition = [24, 44, 64];
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      updateSnake();
      if (gameOver()) {
        gameOverAlert();
        timer.cancel();
      }
    });
  }

  updateSnake() {
    setState(() {
      switch (direction) {
        case Direction.down:
          if (snakePosition.last > 740) {
            snakePosition.add(snakePosition.last - 760 + 20);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;
        case Direction.up:
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last + 760 - 20);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;
        case Direction.right:
          if ((snakePosition.last + 1) % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;
        case Direction.left:
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
        default:
      }
      if (snakePosition.last == foodLocation) {
        totalSpot.removeWhere((element) => snakePosition.contains(element));
        foodLocation = totalSpot[Random().nextInt(totalSpot.length - 1)];
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    final copyList = List.from(snakePosition);
    return snakePosition.length > copyList.toSet().length;
  }

  gameOverAlert() {
    TextEditingController playerNameController = TextEditingController();
    String playerName = '';
    int score = snakePosition.length - 3;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Game Over'),
              content: Column(
                children: [
                  Text('Skormu :  ' + score.toString()),
                  TextField(
                    controller: playerNameController,
                    decoration: InputDecoration(labelText: 'Masukan Namamnu !'),
                    onChanged: (value) {
                      playerName = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    startGame();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Main Lagi'),
                ),
                TextButton(
                  onPressed: () async {
                    // Use your DatabaseHelper class to insert the score into the database
                    await DatabaseHelper().insertHighScoreSnake(playerName, score);

                    // Navigate to the main menu
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GameMenu()),
                    );
                  },
                  child: const Text('Keluar'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (direction != Direction.up && details.delta.dy > 0) {
              direction = Direction.down;
            }
            if (direction != Direction.down && details.delta.dy < 0) {
              direction = Direction.up;
            }
          },
          onHorizontalDragUpdate: (details) {
            if (direction != Direction.left && details.delta.dx > 0) {
              direction = Direction.right;
            }
            if (direction != Direction.right && details.delta.dx < 0) {
              direction = Direction.left;
            }
          },
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 760,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 20,
            ),
            itemBuilder: (context, index) {
              if (snakePosition.contains(index)) {
                return Container(
                  color: Colors.white,
                );
              }
              if (index == foodLocation) {
                return Container(
                  color: Colors.red,
                );
              }
              return Container(
                color: Colors.black,
              );
            },
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 80, // Adjust the width as needed
            child: FloatingActionButton(
              onPressed: () {
                startGame();
              },
              child: start
                  ? Text((snakePosition.length - 3).toString())
                  : const Text('Start'),
            ),
          ),
        ],
      ),
    );
  }
}
