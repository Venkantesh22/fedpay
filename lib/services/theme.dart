// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';

// const Color primaryColor = Color(0xFF39A452);
// Color secondaryColor = const Color(0xFF112031);
// const Color thiryaryColor = Colors.blue;
// Color backgroundDark = const Color(0xff231F20);
// Color backgroundLight = const Color(0xffffffff);
// Color contactUsBackground = const Color(0xFFE2FEE9);

// const Color black = Colors.black;
// const Color white = Colors.white;
// const Color white2 = Color(0xFFF5F7FA);
// const Color whiteAntiFlash = Color(0xFFF1F5F9);
// const Color whiteAppbar = Color(0xFFF8F6F6);
// const Color whiteAppbar2 = Color(0xFFF8F6F6CC);
// Color greyLight = const Color(0xFFC4C4C4);
// Color greyBackGround = const Color(0xFFEFEDED);
// Color grey = const Color(0xFF999999);
// Color greyText = const Color(0xFF5C5B5B);
// Color greyText2 = const Color(0xFF6B7280);
// Color greyText3 = const Color(0xFF355355);
// Color greyText4 = const Color(0xFF9CA3AF);
// Color greyText5 = const Color(0xFFC8C8C8);
// Color greyText6 = const Color(0xFF475569);
// Color greyDark = const Color(0xFFA1A1A1);
// Color greyBorder = const Color(0xFFB9B9B9);
// Color red = Colors.red;
// Color redLight = Colors.red.withValues(alpha: 0.20);
// Color purple = const Color(0xFF9333EA);
// Color purpleLight = const Color(0xFF64748B);
// Color blue = const Color(0xFF2563EB);
// Color blueDark = const Color(0xFF0F172A);
// Color origin = const Color(0xFFEA580C);
// Color cyanDark = const Color(0xFF355355);
// Color primaryColorLight = const Color(0xFFF0FFF4);
// Color yellow = Colors.yellow;

// List<Color> loginBgColor = [
//   const Color(0xFF355355),
//   const Color(0xFF75B7BB),
// ];

// const Color textPrimary = Color(0xff000000);
// const Color textSecondary = Color(0xff838383);
// Map<int, Color> color = const {
//   50: Color.fromRGBO(255, 244, 149, .1),
//   100: Color.fromRGBO(255, 244, 149, .2),
//   200: Color.fromRGBO(255, 244, 149, .3),
//   300: Color.fromRGBO(255, 244, 149, .4),
//   400: Color.fromRGBO(255, 244, 149, .5),
//   500: Color.fromRGBO(255, 244, 149, .6),
//   600: Color.fromRGBO(255, 244, 149, .7),
//   700: Color.fromRGBO(255, 244, 149, .8),
//   800: Color.fromRGBO(255, 244, 149, .9),
//   900: Color.fromRGBO(255, 244, 149, 1),
// };
// MaterialColor colorCustom = MaterialColor(0XFFFFF495, color);

// class CustomTheme {
//   static ThemeData light = ThemeData(
//     fontFamily: "Montserrat",
//     brightness: Brightness.light,
//     useMaterial3: true,
//     scaffoldBackgroundColor: backgroundLight,
//     hintColor: Colors.grey[700],
//     primarySwatch: colorCustom,
//     canvasColor: secondaryColor,
//     primaryColorLight: secondaryColor,
//     splashColor: secondaryColor,
//     shadowColor: Colors.grey[600],
//     cardColor: Colors.grey[100],
//     primaryColor: primaryColor,
//     dividerColor: Colors.grey[600],
//     primaryColorDark: Colors.black,
//     colorScheme: ColorScheme(
//       brightness: Brightness.light,
//       primary: primaryColor,
//       onPrimary: Colors.white,
//       secondary: secondaryColor,
//       onSecondary: Colors.black,
//       error: const Color(0xFFCF6679),
//       onError: const Color(0xFFCF6679),
//       background: backgroundLight,
//       onBackground: Colors.black,
//       surface: backgroundLight,
//       onSurface: Colors.black,
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: primaryColor,
//       actionsIconTheme: IconThemeData(
//         color: backgroundLight,
//       ),
//       iconTheme: IconThemeData(
//         color: black,
//       ),
//       systemOverlayStyle: SystemUiOverlayStyle(
//         // Status bar color
//         statusBarColor: primaryColor,
//         // Status bar brightness (optional)
//         statusBarIconBrightness: Brightness.light,
//         statusBarBrightness: Brightness.light,
//       ),
//     ),
//     typography: Typography.material2021(),
//     textTheme: TextTheme(
//       labelLarge: GoogleFonts.openSans(
//         fontWeight: FontWeight.w400,
//         color: textSecondary,
//         fontSize: 14.0,
//       ),
//       headlineLarge: GoogleFonts.openSans(),
//       headlineMedium: GoogleFonts.openSans(),
//       headlineSmall: GoogleFonts.openSans(),
//       displayLarge: GoogleFonts.publicSans(),
//       displayMedium: GoogleFonts.robotoMono(),
//       displaySmall: GoogleFonts.openSans(),
//       titleLarge: GoogleFonts.openSans(),
//       titleMedium: GoogleFonts.notoSansLimbu(color: black),
//       titleSmall: GoogleFonts.inter(
//         fontWeight: FontWeight.w700,
//         fontSize: 26,
//       ),
//       bodyLarge: GoogleFonts.inter(),
//       bodyMedium: GoogleFonts.inter(
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//       ),
//       bodySmall: GoogleFonts.inter(
//         fontSize: 12,
//         fontWeight: FontWeight.w400,
//       ),
//     ),
//   );
//   static ThemeData dark = ThemeData(
//     brightness: Brightness.dark,
//     useMaterial3: true,
//     scaffoldBackgroundColor: backgroundDark,
//     hintColor: Colors.grey[700],
//     primarySwatch: colorCustom,
//     canvasColor: secondaryColor,
//     primaryColorLight: secondaryColor,
//     splashColor: secondaryColor,
//     shadowColor: Colors.black45,
//     cardColor: Colors.grey[800],
//     primaryColor: primaryColor,
//     dividerColor: Colors.grey[200],
//     primaryColorDark: Colors.white,
//     colorScheme: ColorScheme(
//       brightness: Brightness.dark,
//       primary: primaryColor,
//       onPrimary: Colors.white,
//       secondary: secondaryColor,
//       onSecondary: Colors.black,
//       error: const Color(0xFFCF6679),
//       onError: const Color(0xFFCF6679),
//       background: backgroundDark,
//       onBackground: Colors.white,
//       surface: backgroundDark,
//       onSurface: Colors.white,
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: primaryColor,
//       actionsIconTheme: IconThemeData(
//         color: backgroundLight,
//       ),
//       iconTheme: IconThemeData(
//         color: backgroundLight,
//       ),
//       systemOverlayStyle: SystemUiOverlayStyle(
//         // Status bar color
//         statusBarColor: primaryColor,
//         // Status bar brightness (optional)
//         statusBarIconBrightness: Brightness.light,
//         statusBarBrightness: Brightness.light,
//       ),
//     ),
//     typography: Typography.material2021(),
//     textTheme: TextTheme(
//       labelLarge: GoogleFonts.openSans(
//         fontWeight: FontWeight.w400,
//         color: textSecondary,
//         fontSize: 14.0,
//       ),
//       headlineLarge: GoogleFonts.openSans(),
//       headlineMedium: GoogleFonts.openSans(),
//       headlineSmall: GoogleFonts.openSans(),
//       displayLarge: GoogleFonts.openSans(),
//       displayMedium: GoogleFonts.openSans(),
//       displaySmall: GoogleFonts.openSans(),
//       titleLarge: GoogleFonts.openSans(),
//       titleMedium: GoogleFonts.openSans(),
//       titleSmall: GoogleFonts.openSans(),
//       bodyLarge: GoogleFonts.openSans(),
//       bodyMedium: GoogleFonts.openSans(),
//       bodySmall: GoogleFonts.openSans(),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF0052D9);
Color secondaryColor = const Color(0xFFE53935);
const Color thiryaryColor = Color(0xFF2F80ED);
Color backgroundDark = const Color(0xFF0F172A);
Color backgroundLight = const Color(0xFFF8FAFC);
Color contactUsBackground = const Color(0xFFE8F1FF);

const Color black = Color(0xFF0F172A);
const Color white = Colors.white;
const Color white2 = Color(0xFFF5F7FA);
const Color whiteAntiFlash = Color(0xFFF1F5F9);
const Color whiteAppbar = Color(0xFFF8FAFC);
const Color whiteAppbar2 = Color(0xCCF8FAFC);
Color greyLight = const Color(0xFFCBD5E1);
Color greyBackGround = const Color(0xFFF1F5F9);
Color grey = const Color(0xFF94A3B8);
Color greyText = const Color(0xFF475569);
Color greyText2 = const Color(0xFF64748B);
Color greyText3 = const Color(0xFF355355);
Color greyText4 = const Color(0xFF9CA3AF);
Color greyText5 = const Color(0xFFC8C8C8);
Color greyText6 = const Color(0xFF475569);
Color greyDark = const Color(0xFF64748B);
Color greyBorder = const Color(0xFFE2E8F0);
Color red = const Color(0xFFE53935);
Color redLight = const Color(0xFFFFE5E7);
Color purple = const Color(0xFF9333EA);
Color purpleLight = const Color(0xFF64748B);
Color blue = const Color(0xFF0052D9);
Color blueDark = const Color(0xFF0F172A);
Color origin = const Color(0xFFEA580C);
Color cyanDark = const Color(0xFF355355);
Color primaryColorLight = const Color(0xFFE8F1FF);
Color yellow = const Color(0xFFFACC15);

List<Color> loginBgColor = [
  const Color(0xFF003B9A),
  const Color(0xFF0052D9),
];

const Color textPrimary = Color(0xFF0F172A);
const Color textSecondary = Color(0xFF64748B);

Map<int, Color> color = const {
  50: Color.fromRGBO(232, 241, 255, 0.1),
  100: Color.fromRGBO(232, 241, 255, 0.2),
  200: Color.fromRGBO(232, 241, 255, 0.3),
  300: Color.fromRGBO(232, 241, 255, 0.4),
  400: Color.fromRGBO(232, 241, 255, 0.5),
  500: Color.fromRGBO(232, 241, 255, 0.6),
  600: Color.fromRGBO(232, 241, 255, 0.7),
  700: Color.fromRGBO(232, 241, 255, 0.8),
  800: Color.fromRGBO(232, 241, 255, 0.9),
  900: Color.fromRGBO(232, 241, 255, 1),
};

MaterialColor colorCustom = MaterialColor(
  0xFF0052D9,
  color,
);

class CustomTheme {
  static ThemeData light = ThemeData(
    fontFamily: "Montserrat",
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    hintColor: Colors.grey[700],
    primarySwatch: colorCustom,
    canvasColor: backgroundLight,
    primaryColorLight: primaryColorLight,
    splashColor: primaryColorLight,
    shadowColor: Colors.black.withValues(alpha: 0.08),
    cardColor: Colors.white,
    primaryColor: primaryColor,
    dividerColor: greyBorder,
    primaryColorDark: primaryColor,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      error: secondaryColor,
      onError: Colors.white,
      background: backgroundLight,
      onBackground: textPrimary,
      surface: backgroundLight,
      onSurface: textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      actionsIconTheme: const IconThemeData(
        color: white,
      ),
      iconTheme: const IconThemeData(
        color: white,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w400,
        color: textSecondary,
        fontSize: 14.0,
      ),
      headlineLarge: GoogleFonts.openSans(),
      headlineMedium: GoogleFonts.openSans(),
      headlineSmall: GoogleFonts.openSans(),
      displayLarge: GoogleFonts.publicSans(),
      displayMedium: GoogleFonts.robotoMono(),
      displaySmall: GoogleFonts.openSans(),
      titleLarge: GoogleFonts.openSans(),
      titleMedium: GoogleFonts.openSans(
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.inter(
        fontWeight: FontWeight.w700,
        fontSize: 26,
        color: textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundDark,
    hintColor: Colors.grey[700],
    primarySwatch: colorCustom,
    canvasColor: backgroundDark,
    primaryColorLight: primaryColorLight,
    splashColor: primaryColorLight,
    shadowColor: Colors.black45,
    cardColor: const Color(0xFF172033),
    primaryColor: primaryColor,
    dividerColor: const Color(0xFF334155),
    primaryColorDark: Colors.white,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      error: secondaryColor,
      onError: Colors.white,
      background: backgroundDark,
      onBackground: Colors.white,
      surface: backgroundDark,
      onSurface: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      actionsIconTheme: IconThemeData(
        color: backgroundLight,
      ),
      iconTheme:  IconThemeData(
        color: backgroundLight,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w400,
        color: const Color(0xFFCBD5E1),
        fontSize: 14.0,
      ),
      headlineLarge: GoogleFonts.openSans(
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.openSans(
        color: Colors.white,
      ),
      headlineSmall: GoogleFonts.openSans(
        color: Colors.white,
      ),
      displayLarge: GoogleFonts.openSans(
        color: Colors.white,
      ),
      displayMedium: GoogleFonts.openSans(
        color: Colors.white,
      ),
      displaySmall: GoogleFonts.openSans(
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.openSans(
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.openSans(
        color: Colors.white,
      ),
      titleSmall: GoogleFonts.openSans(
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.openSans(
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.openSans(
        color: const Color(0xFFCBD5E1),
      ),
      bodySmall: GoogleFonts.openSans(
        color: const Color(0xFF94A3B8),
      ),
    ),
  );
}