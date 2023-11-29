import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameMenu extends StatelessWidget {
  const GameMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 80;

    return Container(
      color: Color(0xFF272837),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
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
                modeButton('Ranked Mode', 'Elevate your level',
                    FontAwesomeIcons.trophy, Color(0xFF2F80ED), width),
                modeButton('Time Trial', 'Elevate your level',
                    FontAwesomeIcons.userClock, Color(0xFF2F80ED), width),
                modeButton('Free Play', 'Elevate your level',
                    FontAwesomeIcons.couch, Color(0xFF2F80ED), width),
                modeButton('Pass & Play', 'Elevate your level',
                    FontAwesomeIcons.userFriends, Color(0xFF2F80ED), width),
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

GestureDetector modeButton(
  String title,
  String subtitle,
  IconData icon,
  Color color,
  double width,
) {
  return GestureDetector(
    child: Container(
      width: width,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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
                  child: Text(subtitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontFamily: 'Manrope',
                        color: Colors.white,
                        fontSize: 12,
                      )),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: FaIcon(
              icon,
              size: 35,
              color: Colors.white,
            ),
          )
        ],
      ),
    ),
  );
}
