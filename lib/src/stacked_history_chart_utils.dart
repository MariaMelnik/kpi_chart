import 'package:charts_common/common.dart' as chartsCommon;
import 'package:flutter/material.dart';

chartsCommon.Color convertColor(Color color) {
  if (color == Colors.transparent) return  chartsCommon.Color.transparent;

  String rgb = color.value.toRadixString(16).substring(2);
  String rawHex = "#" + rgb;
  return chartsCommon.Color.fromHex(code: rawHex);
}