import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapdimd/src/core/theme/theme.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(_lightTheme);

  static final _lightTheme = AppTheme.fromJson(json.decode('{"name":"Light","scaffoldBackgroundColor":"#FFFFFF","appBarBackgroundColor":"#F0F0F0","textColor":"#000000","accentColor":"#007AFF","editorBackgroundColor":"#FDFDFD","editorTextColor":"#000000","previewBackgroundColor":"#FFFFFF","previewTextColor":"#000000","sidebarBackgroundColor":"#F5F5F5","sidebarTextColor":"#000000","sidebarHighlightColor":"#E0E0E0"}'));
  static final _darkTheme = AppTheme.fromJson(json.decode('{"name":"Dark","scaffoldBackgroundColor":"#1E1E1E","appBarBackgroundColor":"#2D2D2D","textColor":"#FFFFFF","accentColor":"#007AFF","editorBackgroundColor":"#252526","editorTextColor":"#FFFFFF","previewBackgroundColor":"#1E1E1E","previewTextColor":"#FFFFFF","sidebarBackgroundColor":"#333333","sidebarTextColor":"#FFFFFF","sidebarHighlightColor":"#444444"}'));

  void toggleTheme() {
    state = state.name == 'Light' ? _darkTheme : _lightTheme;
  }
}
