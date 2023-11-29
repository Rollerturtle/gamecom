import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Mino {
  Mino(this.minoType);
  final MType minoType;
  MAngle minoAngle = MAngle.cw000;
  Point<int> offset = const Point<int>(0, 0);
  List<Point<int>> get currentMino =>
      mino(minoType, minoAngle).map((e) => e + offset).toList();

  List<Point<int>> futureMino(List<Point<int>> otherMino) {
    for (var index = 0; index < 22; index++) {
      final tmpMino =
          currentMino.map((e) => Point<int>(e.x, e.y + index)).toList();
      if (_hasCollision(otherMino, minoList: tmpMino)) {
        return tmpMino.map((e) => Point<int>(e.x, e.y - 1)).toList();
      }
    }
    return [];
  }

  bool _outOfRange({List<Point<int>>? minoList}) {
    minoList ??= currentMino;
    for (final mino in minoList) {
      if (mino.x < 0 || mino.x > 9 || mino.y > 19) return true;
    }
    return false;
  }

  bool _hasCollision(List<Point<int>> otherMino, {List<Point<int>>? minoList}) {
    minoList ??= currentMino;
    if (_outOfRange(minoList: minoList)) return true;
    for (final mino in minoList) {
      if (otherMino.contains(mino)) return true;
    }
    return false;
  }

  bool move(Point<int> offset, List<Point<int>> otherMino) {
    this.offset += offset;
    if (_hasCollision(otherMino)) {
      this.offset -= offset;
      return false;
    } else {
      return true;
    }
  }

  Point<int> p(int x, int y) => Point<int>(x, y);
  void rotateCW(List<Point<int>> other) {
    final tmpAngle = minoAngle;
    minoAngle = MAngle.values[(minoAngle.index + 1) % 4];
    if (!_hasCollision(other)) return;
    if (minoType == MType.i) {
      switch (minoAngle) {
        case MAngle.cw000:
          if (move(p(-2, 0), other) ||
              move(p(1, 0), other) ||
              move(p(1, 2), other) ||
              move(p(-2, -1), other)) return;
          break;
        case MAngle.cw090:
          if (move(p(2, 0), other) ||
              move(p(-1, 0), other) ||
              move(p(2, 1), other) ||
              move(p(1, -2), other)) return;
          break;
        case MAngle.cw180:
          if (move(p(-1, 0), other) ||
              move(p(2, 0), other) ||
              move(p(-1, -2), other) ||
              move(p(2, -1), other)) return;
          break;
        case MAngle.cw270:
          if (move(p(2, 0), other) ||
              move(p(-1, 0), other) ||
              move(p(2, -1), other) ||
              move(p(-1, 2), other)) return;
          break;
      }
    } else {
      switch (minoAngle) {
        case MAngle.cw000:
          if (move(p(-1, 0), other) ||
              move(p(-1, 1), other) ||
              move(p(0, -2), other) ||
              move(p(-1, -2), other)) return;
          break;
        case MAngle.cw090:
          if (move(p(-1, 0), other) ||
              move(p(-1, -1), other) ||
              move(p(0, 2), other) ||
              move(p(-1, 2), other)) return;
          break;
        case MAngle.cw180:
          if (move(p(1, 0), other) ||
              move(p(1, 1), other) ||
              move(p(0, -2), other) ||
              move(p(1, -2), other)) return;
          break;
        case MAngle.cw270:
          if (move(p(1, 0), other) ||
              move(p(1, -1), other) ||
              move(p(0, 2), other) ||
              move(p(1, 2), other)) return;
          break;
      }
    }
    minoAngle = tmpAngle;
  }

  void rotateCCW(List<Point<int>> other) {
    final tmpAngle = minoAngle;
    minoAngle = MAngle.values[(minoAngle.index - 1) % 4];
    if (!_hasCollision(other)) return;
    if (minoType == MType.i) {
      switch (minoAngle) {
        case MAngle.cw000:
          if (move(p(2, 0), other) ||
              move(p(-1, 0), other) ||
              move(p(2, -1), other) ||
              move(p(-1, 2), other)) return;
          break;
        case MAngle.cw090:
          if (move(p(1, 0), other) ||
              move(p(-2, 0), other) ||
              move(p(1, 2), other) ||
              move(p(-2, -1), other)) return;
          break;
        case MAngle.cw180:
          if (move(p(-1, 0), other) ||
              move(p(-2, 0), other) ||
              move(p(-2, 1), other) ||
              move(p(1, -2), other)) return;
          break;
        case MAngle.cw270:
          if (move(p(-1, 0), other) ||
              move(p(2, 0), other) ||
              move(p(-1, -2), other) ||
              move(p(2, 1), other)) return;
          break;
      }
    } else {
      switch (minoAngle) {
        case MAngle.cw000:
          if (move(p(1, 0), other) ||
              move(p(1, 1), other) ||
              move(p(0, -2), other) ||
              move(p(1, -2), other)) return;
          break;
        case MAngle.cw090:
          if (move(p(-1, 0), other) ||
              move(p(-1, -1), other) ||
              move(p(0, 2), other) ||
              move(p(-1, 2), other)) return;
          break;
        case MAngle.cw180:
          if (move(p(-1, 0), other) ||
              move(p(-1, 1), other) ||
              move(p(0, -2), other) ||
              move(p(-1, -2), other)) return;
          break;
        case MAngle.cw270:
          if (move(p(1, 0), other) ||
              move(p(1, -1), other) ||
              move(p(0, 2), other) ||
              move(p(1, 2), other)) return;
          break;
      }
    }
    minoAngle = tmpAngle;
  }

  static List<Point<int>> mino(MType minoType, MAngle minoAngle) {
    switch (minoType) {
      case MType.i:
        switch (minoAngle) {
          case MAngle.cw000:
            return const [
              Point<int>(3, -1),
              Point<int>(4, -1),
              Point<int>(5, -1),
              Point<int>(6, -1)
            ];
          case MAngle.cw090:
            return const [
              Point<int>(5, -2),
              Point<int>(5, -1),
              Point<int>(5, 0),
              Point<int>(5, 1)
            ];
          case MAngle.cw180:
            return const [
              Point<int>(3, 0),
              Point<int>(4, 0),
              Point<int>(5, 0),
              Point<int>(6, 0)
            ];
          case MAngle.cw270:
            return const [
              Point<int>(4, -2),
              Point<int>(4, -1),
              Point<int>(4, 0),
              Point<int>(4, 1)
            ];
        }
        break;
      case MType.o:
        switch (minoAngle) {
          case MAngle.cw000:
            return const [
              Point<int>(4, -1),
              Point<int>(4, -2),
              Point<int>(5, -1),
              Point<int>(5, -2)
            ];
          case MAngle.cw090:
            return const [
              Point<int>(4, -1),
              Point<int>(4, -2),
              Point<int>(5, -1),
              Point<int>(5, -2)
            ];
          case MAngle.cw180:
            return const [
              Point<int>(4, -1),
              Point<int>(4, -2),
              Point<int>(5, -1),
              Point<int>(5, -2)
            ];
          case MAngle.cw270:
            return const [
              Point<int>(4, -1),
              Point<int>(4, -2),
              Point<int>(5, -1),
              Point<int>(5, -2)
            ];
        }
        break;
      case MType.t:
        switch (minoAngle) {
          case MAngle.cw000:
            return const [
              Point<int>(3, -1),
              Point<int>(4, -1),
              Point<int>(4, -2),
              Point<int>(5, -1)
            ];
          case MAngle.cw090:
            return const [
              Point<int>(4, -2),
              Point<int>(4, -1),
              Point<int>(4, 0),
              Point<int>(5, -1)
            ];
          case MAngle.cw180:
            return const [
              Point<int>(4, 0),
              Point<int>(3, -1),
              Point<int>(4, -1),
              Point<int>(5, -1)
            ];
          case MAngle.cw270:
            return const [
              Point<int>(3, -1),
              Point<int>(4, -2),
              Point<int>(4, -1),
              Point<int>(4, -0)
            ];
        }
        break;
      case MType.j:
        switch (minoAngle) {
          case MAngle.cw000:
            return const [
              Point<int>(3, -2),
              Point<int>(3, -1),
              Point<int>(4, -1),
              Point<int>(5, -1)
            ];
          case MAngle.cw090:
            return const [
              Point<int>(4, -2),
              Point<int>(4, -1),
              Point<int>(4, 0),
              Point<int>(5, -2)
            ];
          case MAngle.cw180:
            return const [
              Point<int>(3, -1),
              Point<int>(4, -1),
              Point<int>(5, -1),
              Point<int>(5, 0)
            ];
          case MAngle.cw270:
            return const [
              Point<int>(3, 0),
              Point<int>(4, -2),
              Point<int>(4, -1),
              Point<int>(4, 0)
            ];
        }
        break;
      case MType.l:
        switch (minoAngle) {
          case MAngle.cw000:
            return const [
              Point<int>(3, -1),
              Point<int>(4, -1),
              Point<int>(5, -1),
              Point<int>(5, -2)
            ];
          case MAngle.cw090:
            return const [
              Point<int>(4, -2),
              Point<int>(4, -1),
              Point<int>(4, 0),
              Point<int>(5, 0)
            ];
          case MAngle.cw180:
            return const [
              Point<int>(3, -1),
              Point<int>(3, 0),
              Point<int>(4, -1),
              Point<int>(5, -1)
            ];
          case MAngle.cw270:
            return const [
              Point<int>(3, -2),
              Point<int>(4, -2),
              Point<int>(4, -1),
              Point<int>(4, 0)
            ];
        }
        break;
      case MType.s:
        switch (minoAngle) {
          case MAngle.cw000:
            return const [
              Point<int>(3, -1),
              Point<int>(4, -2),
              Point<int>(4, -1),
              Point<int>(5, -2)
            ];
          case MAngle.cw090:
            return const [
              Point<int>(4, -2),
              Point<int>(4, -1),
              Point<int>(5, -1),
              Point<int>(5, 0)
            ];
          case MAngle.cw180:
            return const [
              Point<int>(3, 0),
              Point<int>(4, -1),
              Point<int>(4, 0),
              Point<int>(5, -1)
            ];
          case MAngle.cw270:
            return const [
              Point<int>(3, -2),
              Point<int>(3, -1),
              Point<int>(4, -1),
              Point<int>(4, 0)
            ];
        }
        break;
      case MType.z:
        switch (minoAngle) {
          case MAngle.cw000:
            return const [
              Point<int>(3, -2),
              Point<int>(4, -2),
              Point<int>(4, -1),
              Point<int>(5, -1)
            ];
          case MAngle.cw090:
            return const [
              Point<int>(4, -1),
              Point<int>(4, 0),
              Point<int>(5, -2),
              Point<int>(5, -1)
            ];
          case MAngle.cw180:
            return const [
              Point<int>(3, -1),
              Point<int>(4, -1),
              Point<int>(4, 0),
              Point<int>(5, 0)
            ];
          case MAngle.cw270:
            return const [
              Point<int>(3, -1),
              Point<int>(3, 0),
              Point<int>(4, -2),
              Point<int>(4, -1)
            ];
        }
        break;
    }
    return [];
  }
}

class FreezedMino {
  List<Point<int>> _data = <Point<int>>[];
  List<Point<int>> get data => _data;
  bool get gameOver => _data.where((e) => e.y < 0).isNotEmpty;
  void add(List<Point<int>> otherMino) => _data.addAll(otherMino);
  int delete() {
    var count = 0;
    for (var index = 0; index < 20; index++) {
      if (_data.where((e) => e.y == index).length == 10) {
        _data.removeWhere((e) => e.y == index);
        _data = _data
            .map((e) => e.y < index ? e + const Point<int>(0, 1) : e)
            .toList();
        count++;
      }
    }
    return count;
  }

  void clear() => _data.clear();
}

class RenderMino extends CustomPainter {
  RenderMino({
    required this.mino,
    this.color = Colors.blue,
    this.paintingStyle = PaintingStyle.fill,
  });
  final List<Point<int>> mino;
  final Color color;
  final PaintingStyle paintingStyle;
  void paintMino(Canvas canvas, Paint paint, Size size, List<Point<int>> mino) {
    final base = size.width / 10;
    for (final point in mino) {
      canvas.drawRect(
          Rect.fromLTWH(base * (point.x), base * (point.y), base, base), paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = paintingStyle
      ..color = color
      ..strokeWidth = 2.0;
    paintMino(canvas, paint, size, mino);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

enum MType { i, t, o, s, z, j, l }

enum MAngle { cw000, cw090, cw180, cw270 }
