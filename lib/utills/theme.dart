import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/utills/app_color.dart';

class ThemeClass {

  static ThemeData lightTheme = ThemeData(

      colorScheme:   const ColorScheme.light(
        primary: AppColors.primaryColor,
        onPrimary: Color(0xFFE4FEFE),
        primaryContainer: Color(0xFFB0FFFF),
        onPrimaryContainer: Color(0xFF029494),

        secondary: AppColors.secondaryColor,

        error: Color(0xFFF43B00),
      ),

      fontFamily: GoogleFonts.poppins().fontFamily,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: const Color(0xFFF8F8F8),

  );

}
