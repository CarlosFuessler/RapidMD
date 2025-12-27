import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) {
    return Color(int.parse(json.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  String toJson(Color object) {
    return '#${object.value.toRadixString(16).substring(2, 8)}';
  }
}
