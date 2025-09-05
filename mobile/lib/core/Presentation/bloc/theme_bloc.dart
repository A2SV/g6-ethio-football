import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Theme Events
abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

// Theme States
class ThemeState {
  final ThemeData themeData;
  final bool isDarkMode;
  ThemeState({required this.themeData, required this.isDarkMode});
}

// Theme Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: lightTheme, isDarkMode: false)) {
    on<ToggleThemeEvent>((event, emit) {
      if (state.isDarkMode) {
        emit(ThemeState(themeData: lightTheme, isDarkMode: false));
      } else {
        emit(ThemeState(themeData: darkTheme, isDarkMode: true));
      }
    });
  }
}

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
);
