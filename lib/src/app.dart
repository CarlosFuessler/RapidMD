import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapdimd/src/core/theme/theme_provider.dart';
import 'package:rapdimd/src/features/editor/views/editor_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'RapdiMD',
      theme: ThemeData(
        brightness: appTheme.name == 'Light' ? Brightness.light : Brightness.dark,
        scaffoldBackgroundColor: appTheme.scaffoldBackgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: appTheme.appBarBackgroundColor,
          elevation: 0,
          titleTextStyle: GoogleFonts.inter(
            color: appTheme.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: appTheme.textColor),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: appTheme.accentColor,
          brightness: appTheme.name == 'Light' ? Brightness.light : Brightness.dark,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.interTextTheme(textTheme).apply(
          bodyColor: appTheme.textColor,
          displayColor: appTheme.textColor,
        ),
      ),
      home: const EditorPage(),
    );
  }
}
