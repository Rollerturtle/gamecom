import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamecom/games/minesweeper/view.dart';
import 'package:gamecom/games/snake/snake_name.dart';
import 'package:gamecom/games/tetris/game_board.dart';

class GameMenu extends StatelessWidget {
  const GameMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 80;

    return Container(
      color: Color(0xFF272837),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  'Classic Game',
                  style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontSize: 36,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 0.7
                        ..color = Colors.white),
                ),
                Text(
                  'Flutter Edition',
                  style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontSize: 36,
                      color: Colors.white),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                circButton(FontAwesomeIcons.info),
                circButton(FontAwesomeIcons.medal),
                circButton(FontAwesomeIcons.lightbulb),
              ],
            ),
            Wrap(
              runSpacing: 16,
              children: [
                modeButton(
                  'Tetris',
                  'Classic Tetris Game',
                  FontAwesomeIcons.shapes,
                  Colors.red,
                  width,
                  context, // Add BuildContext here
                ),
                modeButton(
                  'Snake Game',
                  'I Love Python',
                  FontAwesomeIcons.cube,
                  Colors.green,
                  width,
                  context, // Add BuildContext here
                ),
                modeButton(
                  'MineSweeper',
                  'Avoid the mines',
                  FontAwesomeIcons.bomb,
                  Colors.orange,
                  width,
                  context, // Add BuildContext here
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

Padding circButton(IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: RawMaterialButton(
      onPressed: () {},
      fillColor: Colors.white,
      shape: CircleBorder(),
      constraints: BoxConstraints(minHeight: 35, minWidth: 35),
      child: FaIcon(icon, size: 22, color: Color(0xFF2F3041)),
    ),
  );
}

ElevatedButton modeButton(
  String title,
  String subtitle,
  IconData icon,
  Color color,
  double width,
  BuildContext context,
) {
  return ElevatedButton(
    onPressed: () {
      // Menavigasikan pengguna ke halaman yang sesuai berdasarkan judul game
      if (title == 'Tetris') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GameBoard()),
        );
      } else if (title == 'Snake Game') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SnakeGame()),
        );
      } else if (title == 'MineSweeper') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MinesweeperView()),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      primary: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(15.0),
      elevation: 4, // Memberikan elevasi untuk efek bayangan saat ditekan
    ),
    child: Container(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontFamily: 'Manrope',
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontFamily: 'Manrope',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          FaIcon(
            icon,
            size: 35,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}
