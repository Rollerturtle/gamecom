import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamecom/games/minesweeper/view.dart';
import 'package:gamecom/games/snake/snake_name.dart';
import 'package:gamecom/games/tetris/game_board.dart';
import 'package:gamecom/db/database_helper.dart';
import 'package:collection/collection.dart';

import 'dart:math';

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
                circButton(FontAwesomeIcons.info, context),
                circButton(FontAwesomeIcons.medal, context),
                circButton(FontAwesomeIcons.lightbulb, context),
                circButton(FontAwesomeIcons.refresh, context),
              ],
            ),
            Wrap(
              runSpacing: 16,
              children: [
                modeButton(
                  'Tetris',
                  'Game Tetris Klasik',
                  FontAwesomeIcons.shapes,
                  Colors.red,
                  width,
                  context, // Add BuildContext here
                ),
                modeButton(
                  'Snake Game',
                  'Merayap hingga jadi besar!',
                  FontAwesomeIcons.cube,
                  Colors.green,
                  width,
                  context, // Add BuildContext here
                ),
                modeButton(
                  'MineSweeper',
                  'Ledakan Semua Bombnya!',
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

Padding circButton(IconData icon, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: RawMaterialButton(
      onPressed: () async {
        // Mark the function as async
        if (icon == FontAwesomeIcons.info) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFF1E1E1E), // Dark background color
                title: Text(
                  'Versi',
                  style: TextStyle(color: Colors.white), // White text color
                ),
                content: Text(
                  '0.5.2',
                  style: TextStyle(color: Colors.white), // White text color
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Tutup',
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                  ),
                ],
              );
            },
          );
        } else if (icon == FontAwesomeIcons.medal) {
          List<Map<String, dynamic>> snakeHighScores =
              await DatabaseHelper().getHighScoresSnake();
          List<Map<String, dynamic>> tetrisHighScores = await DatabaseHelper()
              .getHighScoresTetris(); // Menambahkan ini untuk mendapatkan skor tertinggi Tetris

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFF1E1E1E), // Dark background color
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.medal, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Leaderboard',
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                  ],
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(), // Spacer untuk menempatkan logo cube di tengah
                        FaIcon(FontAwesomeIcons.cube, color: Colors.white),
                        SizedBox(width: 8),
                        Spacer(), // Spacer tambahan jika diperlukan
                      ],
                    ),
                    SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(
                        color: Colors.white, // Set color to white
                      ),
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Username',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // Putih
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Skor',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Sort the scores in descending order
                        ...snakeHighScores
                            .where((scoreEntry) =>
                                scoreEntry['playerName'] != null)
                            .toList()
                            .cast<Map<String, dynamic>>()
                            .sorted((a, b) => b['score'].compareTo(a['score']))
                            .take(3)
                            .map((scoreEntry) => TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            scoreEntry['playerName'].toString(),
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            scoreEntry['score'].toString(),
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.shapes,
                            color: Colors.white), // Ikon shapes
                        SizedBox(width: 8),
                      ],
                    ), // Menampilkan judul tabel Tetris
                    SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(
                        color: Colors.white, // Set color to white
                      ),
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Username',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Skor',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Menampilkan data skor tertinggi Tetris di sini
                        ...tetrisHighScores
                            .where((scoreEntry) =>
                                scoreEntry['playerName'] != null)
                            .toList()
                            .cast<Map<String, dynamic>>()
                            .sorted((a, b) => b['score'].compareTo(a['score']))
                            .take(3)
                            .map((scoreEntry) => TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            scoreEntry['playerName'].toString(),
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            scoreEntry['score'].toString(),
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (icon == FontAwesomeIcons.lightbulb) {
          final List<String> tips = [
            'Tip 1: Rencanakan penempatan blok dengan cermat untuk memaksimalkan ruang dan menghindari terbentuknya celah yang sulit diisi.',
            'Tip 2: Pahami berbagai cara merotasi blok untuk menyesuaikan dengan kebutuhan ruang yang ada di papan permainan.',
            'Tip 3: Prioritaskan untuk membersihkan baris-baris penuh secepat mungkin untuk menghindari tumpukan blok yang tinggi.',
            'Tip 4: Kendalikan ular dengan hati-hati untuk menghindari menabrak diri sendiri atau tepi layar.',
            'Tip 5: Perhatikan rencana jangka panjang untuk menghindari posisi yang sulit dikeluarkan.',
            'Tip 6: Rencanakan penempatan blok dengan cermat untuk memaksimalkan ruang dan menghindari terbentuknya celah yang sulit diisi.',
            'Tip 7: Gunakan angka-angka di sekitar kotak untuk menganalisis dan menentukan letak ranjau.',
            'Tip 8: Gunakan dinding ular sendiri untuk memotong jalur dan mendapatkan makanan dengan efisien.',
            'Tip 9: Mulai mengungkapkan kotak dari pinggir untuk memaksimalkan informasi yang diperoleh.',
          ];

          final String randomTip = tips[Random().nextInt(tips.length)];

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFF1E1E1E), // Dark background color
                title: Text(
                  'Game Tip',
                  style: TextStyle(color: Colors.white), // White text color
                ),
                content: Text(
                  randomTip,
                  style: TextStyle(color: Colors.white), // White text color
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                  ),
                ],
              );
            },
          );
        } else if (icon == FontAwesomeIcons.refresh) {
          // Tampilkan dialog konfirmasi sebelum mereset highscore
          bool resetConfirmed = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFF1E1E1E), // Dark background color
                title: Text(
                  'Reset Highscore',
                  style: TextStyle(color: Colors.white), // White text color
                ),
                content: Text(
                  'Anda yakin ingin mereset highscore?',
                  style: TextStyle(color: Colors.white), // White text color
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Batalkan reset
                    },
                    child: Text(
                      'Batal',
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Konfirmasi reset
                    },
                    child: Text(
                      'Reset',
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                  ),
                ],
              );
            },
          );

          // Jika pengguna mengonfirmasi reset, reset highscore
          if (resetConfirmed) {
            await DatabaseHelper().resetHighScores();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Color(0xFF1E1E1E), // Dark background color
                  title: Text(
                    'Highscore Reset',
                    style: TextStyle(color: Colors.white), // White text color
                  ),
                  content: Text(
                    'Highscore telah direset.',
                    style: TextStyle(color: Colors.white), // White text color
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'OK',
                        style:
                            TextStyle(color: Colors.white), // White text color
                      ),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
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
