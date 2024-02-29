import 'package:flutter/material.dart';
import 'package:expense_tracker_app/widgets/expenses_screen.dart';
import 'package:flutter/services.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

ThemeData buildDefaultDarkThemeData() {
  return ThemeData.dark().copyWith(
    colorScheme: kDarkColorScheme,
    cardTheme: const CardTheme().copyWith(
      color: kDarkColorScheme.secondaryContainer,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kDarkColorScheme.primaryContainer,
        foregroundColor: kDarkColorScheme.onPrimaryContainer,
      ),
    ),
    textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.normal,
            color: kDarkColorScheme.onSecondaryContainer,
            fontSize: 20,
          ),
          titleMedium: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontSize: 14,
          ),
        ),
  );
}

ThemeData buildDefaultThemeData() {
  return ThemeData().copyWith(
    colorScheme: kColorScheme,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: kColorScheme.onPrimaryContainer,
      foregroundColor: kColorScheme.primaryContainer,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: const CardTheme().copyWith(
      color: kColorScheme.secondaryContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kColorScheme.primaryContainer,
      ),
    ),
    textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.normal,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 20,
          ),
        ),
  );
}

void lockingScreen() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    return runApp(
      MaterialApp(
        darkTheme: buildDefaultDarkThemeData(),
        theme: buildDefaultThemeData(),
        // themeMode: ThemeMode.system, //default
        home: const ExpensesScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  });
}

void main() {
  runApp(
    MaterialApp(
      darkTheme: buildDefaultDarkThemeData(),
      theme: buildDefaultThemeData(),
      // themeMode: ThemeMode.system, //default
      home: const ExpensesScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );

  // lockingScreen();
}
