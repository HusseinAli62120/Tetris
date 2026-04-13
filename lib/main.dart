import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/pages/game/game.dart';
import 'package:tetris/pages/start.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tetris/theme/light_mode.dart';
import 'package:tetris/theme/dark_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        final ThemeData currentTheme = Theme.of(context);
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            // Status bar
            statusBarColor: currentTheme.colorScheme.primary,
            statusBarIconBrightness: currentTheme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,

            // Navigation bar
            systemNavigationBarColor: currentTheme.colorScheme.primary,
            systemNavigationBarIconBrightness:
                currentTheme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
      routes: {"/": (context) => Start(), "/game": (context) => Game()},
    );
  }
}
