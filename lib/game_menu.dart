import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamecom/games/minesweeper/view.dart';
import 'package:gamecom/games/snake/snake_name.dart';
import 'package:gamecom/games/tetris/game_board.dart';
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
      onPressed: () {
        if (icon == FontAwesomeIcons.info) {
          // Menampilkan versi aplikasi pada dialog saat tombol info ditekan
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('App Version'),
                content: Text(
                    'Your App Version Here'), // Ganti dengan versi aplikasi yang sesuai
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        } else if (icon == FontAwesomeIcons.medal) {
          // Menampilkan popup tabel kosong saat tombol medal ditekan
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Medal Information'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Table 1:'),
                    SizedBox(height: 8),
                    // Tabel kosong pertama
                    Table(
                      border: TableBorder.all(),
                      children: [
                        // Isi tabel dapat ditambahkan di sini
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('Table 2:'),
                    SizedBox(height: 8),
                    // Tabel kosong kedua
                    Table(
                      border: TableBorder.all(),
                      children: [
                        // Isi tabel dapat ditambahkan di sini
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        } else if (icon == FontAwesomeIcons.lightbulb) {
          // Menampilkan tips secara random saat tombol lightbulb ditekan
          final List<String> tips = [
            'Tip 1: Rencanakan penempatan blok dengan cermat untuk memaksimalkan ruang dan menghindari terbentuknya celah yang sulit diisi.',
            'Tip 2: Pahami berbagai cara merotasi blok untuk menyesuaikan dengan kebutuhan ruang yang ada di papan permainan.',
            'Tip 3: DPrioritaskan untuk membersihkan baris-baris penuh secepat mungkin untuk menghindari tumpukan blok yang tinggi.',
            'Tip 4: Kendalikan ular dengan hati-hati untuk menghindari menabrak diri sendiri atau tepi layar.',
            'Tip 5: Perhatikan rencana jangka panjang untuk menghindari posisi yang sulit dikeluarkan.',
            'Tip 6: Rencanakan penempatan blok dengan cermat untuk memaksimalkan ruang dan menghindari terbentuknya celah yang sulit diisi.',
            'Tip 7: Gunakan angka-angka di sekitar kotak untuk menganalisis dan menentukan letak ranjau.',
            'Tip 8: Gunakan dinding ular sendiri untuk memotong jalur dan mendapatkan makanan dengan efisien.',
            'Tip 9: Mulai mengungkapkan kotak dari pinggir untuk memaksimalkan informasi yang diperoleh.',

            // Tambahkan lebih banyak tips sesuai kebutuhan
          ];

          // Mengambil tip secara acak dari daftar tips
          final String randomTip = tips[Random().nextInt(tips.length)];

          // Menampilkan tip pada dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Game Tip'),
                content: Text(randomTip),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
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
