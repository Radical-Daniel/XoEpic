import 'package:flutter/material.dart';
import '../style/palette.dart';
import '../games_services/grid.dart';

Palette _palette = Palette();
const OPTION_STYLE = TextStyle(color: Colors.white);
Color ICON_COLORS(Node element) {
  if (element.isForPlayer1) {
    if (element.isHighlighted) {
      return _palette.redPen;
    } else if (element.checked) {
      return _palette.darkPen;
    } else {
      return _palette.trueWhite;
    }
  } else {
    if (element.isHighlighted) {
      return _palette.darkPen;
    } else if (element.checked) {
      return _palette.redPen;
    } else {
      return _palette.trueWhite;
    }
  }
}
