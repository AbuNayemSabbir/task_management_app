import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/utills/app_utills.dart';



class ThemeClass {

  static ThemeData lightTheme = ThemeData(

      colorScheme:   const ColorScheme.light(
        primary: AppUTills.primaryColor,
        onPrimary: Color(0xFFE4FEFE),
        primaryContainer: Color(0xFFB0FFFF),
        onPrimaryContainer: Color(0xFF029494),

        secondary: AppUTills.secondaryColor,
        onSecondary: Color(0xFFF1EBFC),
        secondaryContainer: Color(0xFFB189F1),
        onSecondaryContainer: Color(0xFF3C117E),

        error: Color(0xFFF43B00),
        onError: Color(0xFFFEC3B1),
        errorContainer:Color(0xFFFF8159),
        onErrorContainer: Color(0xFF7C2104),
      ),

      fontFamily: GoogleFonts.publicSans().fontFamily,
      primaryColor: AppUTills.primaryColor,

      scaffoldBackgroundColor: const Color(0xFFE5E5E5),
  );

}
