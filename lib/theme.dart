import 'package:flutter/material.dart';

const _primaryColorLight = Color(0xff34BB78);
Color _primaryColorDark =
    HSLColor.fromColor(const Color(0xff34BB78)).withLightness(0.5).toColor();
// const _primaryColorDark = Color(0xFF6623bf);
final lightTheme = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(toolbarHeight: 60),
  switchTheme: SwitchThemeData(
    trackColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return _primaryColorLight.withOpacity(.48);
      }
      return Colors.grey.withOpacity(.80);
    }),
    thumbColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return _primaryColorLight;
      }
      return Colors.grey.withOpacity(.38);
    }),
  ),
  dialogBackgroundColor: const Color(0xFFFCFCFC),
  colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _primaryColorLight,
      onPrimary: Colors.white,
      secondary: Colors.grey,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      background: Color(0xFFFAFAFB),
      onBackground: Colors.black,
      surface: Color(0xFFFCFCFC),
      onSurface: Colors.black),
  bottomSheetTheme: const BottomSheetThemeData(
      // backgroundColor: Color(0xFFB1CBD0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0)))),
  snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xffe9eced), behavior: SnackBarBehavior.floating),
  progressIndicatorTheme:
      const ProgressIndicatorThemeData(color: _primaryColorLight),
  hintColor: Colors.black38,
  // accentColor: Colors.blueGrey.shade100,
  // accentColor: const Color(0xFFB1CBD0),
  cardTheme: CardTheme(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
  iconTheme: const IconThemeData(color: Colors.black),
  cardColor: const Color(0xFFFCFCFC),
  fontFamily: 'DM Sans',
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    textStyle: MaterialStateProperty.all(
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
    backgroundColor: MaterialStateProperty.all(_primaryColorLight),
  )),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: buttonColors)
        .copyWith(secondary: const Color(0xFFFFFFFF)),
  ),
  textTheme: Typography.blackCupertino.copyWith(
      subtitle1: const TextStyle(color: Color(0xff424245)),
      subtitle2: const TextStyle(color: Color(0xFF686873))),
  primaryColor: _primaryColorLight,
  scaffoldBackgroundColor: const Color(0xFFE5E5E5),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: _primaryColorLight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    focusColor: _primaryColorLight,
    labelStyle: const TextStyle(color: Colors.black38),
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 0.0, color: Colors.black26),
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    border: OutlineInputBorder(
      borderSide: const BorderSide(width: 0.0),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

const int _btnLightTheme = 0xFFFFFFFF;
const MaterialColor buttonColors = MaterialColor(_btnLightTheme, <int, Color>{
  50: Color(0xFFFFFFFF),
  100: Color(0xFF351262),
  200: Color(0xFFEBEBEC),
  700: Color(0xFF351262),
  800: Color(0xFFEBEBEC),
});

final darkTheme = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(toolbarHeight: 60),
  switchTheme: SwitchThemeData(
    trackColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return _primaryColorDark.withOpacity(.48);
      }
      return Colors.white.withOpacity(.48);
    }),
    thumbColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return _primaryColorDark;
      }
      return Colors.white;
    }),
  ),
  colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: _primaryColorDark,
      onPrimary: Colors.white,
      secondary: Colors.grey,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      background: const Color(0xFF15202B),
      onBackground: Colors.white,
      surface: const Color(0xFF15202B),
      onSurface: Colors.white),
  bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xff1c2c3c),
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0)))),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.white,
    behavior: SnackBarBehavior.floating,
  ),
  hintColor: Colors.grey,
  progressIndicatorTheme: ProgressIndicatorThemeData(color: _primaryColorDark),
  dialogBackgroundColor: Colors.black,
  cardTheme: CardTheme(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      color: const Color(0xff1c2c3c),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
  iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
  cardColor: const Color(0xFF202021),
  fontFamily: 'DM Sans',
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    textStyle: MaterialStateProperty.all(
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
    backgroundColor: MaterialStateProperty.all(_primaryColorDark),
  )),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: buttonColors)
        .copyWith(secondary: const Color(0xFFFFFFFF)),
  ),
  textTheme: Typography.whiteCupertino.copyWith(
    subtitle1: const TextStyle(color: Colors.white70),
    subtitle2: const TextStyle(color: Colors.grey),
  ),
  primaryColorDark: const Color(0xFF15202B),
  primaryColor: _primaryColorDark,
  scaffoldBackgroundColor: const Color(0xFF15202B),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: _primaryColorDark,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0))),
    focusColor: _primaryColorDark,
    labelStyle: const TextStyle(color: Colors.white),
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
