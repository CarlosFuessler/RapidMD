import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rapdimd/src/core/theme/color_converter.dart';

part 'theme.freezed.dart';
part 'theme.g.dart';

@freezed
class AppTheme with _$AppTheme {
  const factory AppTheme({
    required String name,
    @ColorConverter() required Color scaffoldBackgroundColor,
    @ColorConverter() required Color appBarBackgroundColor,
    @ColorConverter() required Color textColor,
    @ColorConverter() required Color accentColor,
    @ColorConverter() required Color editorBackgroundColor,
    @ColorConverter() required Color editorTextColor,
    @ColorConverter() required Color previewBackgroundColor,
    @ColorConverter() required Color previewTextColor,
    @ColorConverter() required Color sidebarBackgroundColor,
    @ColorConverter() required Color sidebarTextColor,
    @ColorConverter() required Color sidebarHighlightColor,
  }) = _AppTheme;

  factory AppTheme.fromJson(Map<String, dynamic> json) => _$AppThemeFromJson(json);
}


