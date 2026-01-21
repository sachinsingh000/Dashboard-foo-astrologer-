import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the astrology consultation application.
class AppTheme {
 AppTheme._();

 // Grounded Sophistication Color Palette
 static const Color primaryLight =
 Color(0xFF2C5F5D); // Deep teal for trust and professionalism
 static const Color primaryVariantLight =
 Color(0xFF1A4A47); // Darker teal variant
 static const Color secondaryLight =
 Color(0xFF8B7355); // Warm bronze for accent elements
 static const Color secondaryVariantLight =
 Color(0xFF6B5A42); // Darker bronze variant
 static const Color backgroundLight =
 Color(0xFFFAFAFA); // Soft off-white for battery efficiency
 static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white for cards
 static const Color errorLight =
 Color(0xFFA0522D); // Warm sienna for approachable errors
 static const Color successLight =
 Color(0xFF4A7C59); // Forest green for earnings
 static const Color warningLight =
 Color(0xFFB8860B); // Muted gold for pending states
 static const Color accentLight =
 Color(0xFFE8F4F8); // Subtle teal tint for backgrounds
 static const Color onPrimaryLight = Color(0xFFFFFFFF);
 static const Color onSecondaryLight = Color(0xFFFFFFFF);
 static const Color onBackgroundLight =
 Color(0xFF1A1A1A); // Near-black for optimal readability
 static const Color onSurfaceLight = Color(0xFF1A1A1A);
 static const Color onErrorLight = Color(0xFFFFFFFF);

 // Dark theme colors (adapted for professional astrology app)
 static const Color primaryDark =
 Color(0xFF4A8B87); // Lighter teal for dark mode
 static const Color primaryVariantDark =
 Color(0xFF2C5F5D); // Original teal as variant
 static const Color secondaryDark =
 Color(0xFFB8A082); // Lighter bronze for dark mode
 static const Color secondaryVariantDark =
 Color(0xFF8B7355); // Original bronze as variant
 static const Color backgroundDark =
 Color(0xFF121212); // Standard dark background
 static const Color surfaceDark =
 Color(0xFF1E1E1E); // Elevated surface in dark mode
 static const Color errorDark =
 Color(0xFFD4845A); // Lighter sienna for dark mode
 static const Color successDark = Color(0xFF6BA876); // Lighter forest green
 static const Color warningDark = Color(0xFFE6B84D); // Lighter muted gold
 static const Color accentDark =
 Color(0xFF2A3F3E); // Darker teal tint for dark backgrounds
 static const Color onPrimaryDark = Color(0xFF000000);
 static const Color onSecondaryDark = Color(0xFF000000);
 static const Color onBackgroundDark = Color(0xFFFFFFFF);
 static const Color onSurfaceDark = Color(0xFFFFFFFF);
 static const Color onErrorDark = Color(0xFF000000);

 // Text colors with proper emphasis levels
 static const Color textPrimaryLight =
 Color(0xFF1A1A1A); // Near-black for primary text
 static const Color textSecondaryLight =
 Color(0xFF6B7280); // Medium gray for secondary text
 static const Color textDisabledLight =
 Color(0xFFB0B0B0); // Light gray for disabled text

 static const Color textPrimaryDark =
 Color(0xFFFFFFFF); // White for primary text in dark mode
 static const Color textSecondaryDark =
 Color(0xFFB0B0B0); // Light gray for secondary text in dark mode
 static const Color textDisabledDark =
 Color(0xFF6B7280); // Medium gray for disabled text in dark mode

 // Border and divider colors
 static const Color borderLight =
 Color(0xFFE5E7EB); // Minimal borders for functional separation
 static const Color borderDark = Color(0xFF374151); // Dark mode borders
 static const Color dividerLight = Color(0xFFE5E7EB);
 static const Color dividerDark = Color(0xFF374151);

 // Shadow colors for subtle elevation
 static const Color shadowLight = Color(0x0F000000); // Gentle shadows
 static const Color shadowDark =
 Color(0x1FFFFFFF); // Subtle shadows for dark mode

 /// Light theme optimized for professional astrology consultation
 static ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme(
   brightness: Brightness.light,
   primary: primaryLight,
   onPrimary: onPrimaryLight,
   primaryContainer: accentLight,
   onPrimaryContainer: primaryLight,
   secondary: secondaryLight,
   onSecondary: onSecondaryLight,
   secondaryContainer: secondaryLight.withAlpha(26),
   onSecondaryContainer: secondaryLight,
   tertiary: successLight,
   onTertiary: onPrimaryLight,
   tertiaryContainer: successLight.withAlpha(26),
   onTertiaryContainer: successLight,
   error: errorLight,
   onError: onErrorLight,
   errorContainer: errorLight.withAlpha(26),
   onErrorContainer: errorLight,
   surface: surfaceLight,
   onSurface: onSurfaceLight,
   onSurfaceVariant: textSecondaryLight,
   outline: borderLight,
   outlineVariant: dividerLight,
   shadow: shadowLight,
   scrim: shadowLight,
   inverseSurface: surfaceDark,
   onInverseSurface: onSurfaceDark,
   inversePrimary: primaryDark,
  ),
  scaffoldBackgroundColor: backgroundLight,
  cardColor: surfaceLight,
  dividerColor: dividerLight,

  // AppBar theme for professional consultation interface
  appBarTheme: AppBarThemeData(
   backgroundColor: surfaceLight,
   foregroundColor: textPrimaryLight,
   elevation: 1.0, // Subtle elevation for hierarchy
   shadowColor: shadowLight,
   titleTextStyle: GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimaryLight,
   ),
   iconTheme: const IconThemeData(
    color: textPrimaryLight,
    size: 24,
   ),
  ),

  // Card theme for consultation cards and content sections
  cardTheme: CardThemeData(
   color: surfaceLight,
   elevation: 2.0, // Gentle depth without heaviness
   shadowColor: shadowLight,
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
   ),
   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),

  // Bottom navigation for contextual session navigation
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
   backgroundColor: surfaceLight,
   selectedItemColor: primaryLight,
   unselectedItemColor: textSecondaryLight,
   elevation: 4.0,
   type: BottomNavigationBarType.fixed,
   selectedLabelStyle: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
   ),
   unselectedLabelStyle: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
   ),
  ),

  // FAB theme for strategic placement during consultations
  floatingActionButtonTheme: FloatingActionButtonThemeData(
   backgroundColor: primaryLight,
   foregroundColor: onPrimaryLight,
   elevation: 4.0,
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
   ),
  ),

  // Button themes for consultation actions
  elevatedButtonTheme: ElevatedButtonThemeData(
   style: ElevatedButton.styleFrom(
    foregroundColor: onPrimaryLight,
    backgroundColor: primaryLight,
    elevation: 2.0,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(12.0),
    ),
    textStyle: GoogleFonts.inter(
     fontSize: 16,
     fontWeight: FontWeight.w600,
    ),
   ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
   style: OutlinedButton.styleFrom(
    foregroundColor: primaryLight,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    side: const BorderSide(color: primaryLight, width: 1.5),
    shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(12.0),
    ),
    textStyle: GoogleFonts.inter(
     fontSize: 16,
     fontWeight: FontWeight.w500,
    ),
   ),
  ),

  textButtonTheme: TextButtonThemeData(
   style: TextButton.styleFrom(
    foregroundColor: primaryLight,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(8.0),
    ),
    textStyle: GoogleFonts.inter(
     fontSize: 14,
     fontWeight: FontWeight.w500,
    ),
   ),
  ),

  // Typography optimized for mobile consultation interfaces
  textTheme: _buildLightTextTheme(),

  // Input decoration for consultation forms
  inputDecorationTheme: InputDecorationThemeData(
   fillColor: accentLight,
   filled: true,
   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
   border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: borderLight, width: 1.0),
   ),
   enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: borderLight, width: 1.0),
   ),
   focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: primaryLight, width: 2.0),
   ),
   errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: errorLight, width: 1.0),
   ),
   focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: errorLight, width: 2.0),
   ),
   labelStyle: GoogleFonts.inter(
    color: textSecondaryLight,
    fontSize: 16,
    fontWeight: FontWeight.w400,
   ),
   hintStyle: GoogleFonts.inter(
    color: textDisabledLight,
    fontSize: 16,
    fontWeight: FontWeight.w400,
   ),
  ),

  // Interactive element themes
  switchTheme: SwitchThemeData(
   thumbColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
     return primaryLight;
    }
    return textDisabledLight;
   }),
   trackColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
     return primaryLight.withAlpha(77);
    }
    return textDisabledLight.withAlpha(51);
   }),
  ),

  checkboxTheme: CheckboxThemeData(
   fillColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
     return primaryLight;
    }
    return Colors.transparent;
   }),
   checkColor: WidgetStateProperty.all(onPrimaryLight),
   side: const BorderSide(color: borderLight, width: 2.0),
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4.0),
   ),
  ),

  radioTheme: RadioThemeData(
   fillColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
     return primaryLight;
    }
    return textSecondaryLight;
   }),
  ),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
   color: primaryLight,
   linearTrackColor: accentLight,
   circularTrackColor: accentLight,
  ),

  sliderTheme: SliderThemeData(
   activeTrackColor: primaryLight,
   thumbColor: primaryLight,
   overlayColor: primaryLight.withAlpha(51),
   inactiveTrackColor: accentLight,
   trackHeight: 4.0,
  ),

  // Tab bar theme for consultation categories
  tabBarTheme: TabBarThemeData(
   labelColor: primaryLight,
   unselectedLabelColor: textSecondaryLight,
   indicatorColor: primaryLight,
   indicatorSize: TabBarIndicatorSize.label,
   labelStyle: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
   ),
   unselectedLabelStyle: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
   ),
  ),

  // Tooltip theme for guidance elements
  tooltipTheme: TooltipThemeData(
   decoration: BoxDecoration(
    color: textPrimaryLight.withAlpha(230),
    borderRadius: BorderRadius.circular(8.0),
   ),
   textStyle: GoogleFonts.inter(
    color: surfaceLight,
    fontSize: 12,
    fontWeight: FontWeight.w400,
   ),
   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  ),

  // SnackBar theme for consultation feedback
  snackBarTheme: SnackBarThemeData(
   backgroundColor: textPrimaryLight,
   contentTextStyle: GoogleFonts.inter(
    color: surfaceLight,
    fontSize: 14,
    fontWeight: FontWeight.w400,
   ),
   actionTextColor: secondaryLight,
   behavior: SnackBarBehavior.floating,
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
   ),
   elevation: 4.0,
  ),

  // Dialog theme for consultation modals
  dialogTheme: DialogThemeData(
   backgroundColor: surfaceLight,
   elevation: 8.0,
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
   ),
   titleTextStyle: GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimaryLight,
   ),
   contentTextStyle: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimaryLight,
   ),
  ),

  // Bottom sheet theme for contextual actions
  bottomSheetTheme: const BottomSheetThemeData(
   backgroundColor: surfaceLight,
   elevation: 8.0,
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
     top: Radius.circular(20.0),
    ),
   ),
  ),
 );

 /// Dark theme optimized for evening consultations
 static ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
   brightness: Brightness.dark,
   primary: primaryDark,
   onPrimary: onPrimaryDark,
   primaryContainer: accentDark,
   onPrimaryContainer: primaryDark,
   secondary: secondaryDark,
   onSecondary: onSecondaryDark,
   secondaryContainer: secondaryDark.withAlpha(51),
   onSecondaryContainer: secondaryDark,
   tertiary: successDark,
   onTertiary: onPrimaryDark,
   tertiaryContainer: successDark.withAlpha(51),
   onTertiaryContainer: successDark,
   error: errorDark,
   onError: onErrorDark,
   errorContainer: errorDark.withAlpha(51),
   onErrorContainer: errorDark,
   surface: surfaceDark,
   onSurface: onSurfaceDark,
   onSurfaceVariant: textSecondaryDark,
   outline: borderDark,
   outlineVariant: dividerDark,
   shadow: shadowDark,
   scrim: shadowDark,
   inverseSurface: surfaceLight,
   onInverseSurface: onSurfaceLight,
   inversePrimary: primaryLight,
  ),
  scaffoldBackgroundColor: backgroundDark,
  cardColor: surfaceDark,
  dividerColor: dividerDark,
  appBarTheme: AppBarThemeData(
   backgroundColor: surfaceDark,
   foregroundColor: textPrimaryDark,
   elevation: 1.0,
   shadowColor: shadowDark,
   titleTextStyle: GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimaryDark,
   ),
   iconTheme: const IconThemeData(
    color: textPrimaryDark,
    size: 24,
   ),
  ),
  cardTheme: CardThemeData(
   color: surfaceDark,
   elevation: 2.0,
   shadowColor: shadowDark,
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
   ),
   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
   backgroundColor: surfaceDark,
   selectedItemColor: primaryDark,
   unselectedItemColor: textSecondaryDark,
   elevation: 4.0,
   type: BottomNavigationBarType.fixed,
   selectedLabelStyle: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
   ),
   unselectedLabelStyle: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
   ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
   backgroundColor: primaryDark,
   foregroundColor: onPrimaryDark,
   elevation: 4.0,
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
   ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
   style: ElevatedButton.styleFrom(
    foregroundColor: onPrimaryDark,
    backgroundColor: primaryDark,
    elevation: 2.0,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(12.0),
    ),
    textStyle: GoogleFonts.inter(
     fontSize: 16,
     fontWeight: FontWeight.w600,
    ),
   ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
   style: OutlinedButton.styleFrom(
    foregroundColor: primaryDark,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    side: const BorderSide(color: primaryDark, width: 1.5),
    shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(12.0),
    ),
    textStyle: GoogleFonts.inter(
     fontSize: 16,
     fontWeight: FontWeight.w500,
    ),
   ),
  ),
  textButtonTheme: TextButtonThemeData(
   style: TextButton.styleFrom(
    foregroundColor: primaryDark,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(8.0),
    ),
    textStyle: GoogleFonts.inter(
     fontSize: 14,
     fontWeight: FontWeight.w500,
    ),
   ),
  ),
  textTheme: _buildDarkTextTheme(),
  inputDecorationTheme: InputDecorationThemeData(
   fillColor: accentDark,
   filled: true,
   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
   border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: borderDark, width: 1.0),
   ),
   enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: borderDark, width: 1.0),
   ),
   focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: primaryDark, width: 2.0),
   ),
   errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: errorDark, width: 1.0),
   ),
   focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: errorDark, width: 2.0),
   ),
   labelStyle: GoogleFonts.inter(
    color: textSecondaryDark,
    fontSize: 16,
    fontWeight: FontWeight.w400,
   ),
   hintStyle: GoogleFonts.inter(
    color: textDisabledDark,
    fontSize: 16,
    fontWeight: FontWeight.w400,
   ),
  ),
  switchTheme: SwitchThemeData(
   thumbColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
     return primaryDark;
    }
    return textDisabledDark;
   }),
   trackColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
     return primaryDark.withAlpha(77);
    }
    return textDisabledDark.withAlpha(51);
   }),
  ),
  checkboxTheme: CheckboxThemeData(
   fillColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
     return primaryDark;
    }
    return Colors.transparent;
   }),
   checkColor: WidgetStateProperty.all(onPrimaryDark),
   side: const BorderSide(color: borderDark, width: 2.0),
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4.0),
   ),
  ),
  radioTheme: RadioThemeData(
   fillColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
     return primaryDark;
    }
    return textSecondaryDark;
   }),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
   color: primaryDark,
   linearTrackColor: accentDark,
   circularTrackColor: accentDark,
  ),
  sliderTheme: SliderThemeData(
   activeTrackColor: primaryDark,
   thumbColor: primaryDark,
   overlayColor: primaryDark.withAlpha(51),
   inactiveTrackColor: accentDark,
   trackHeight: 4.0,
  ),
  tabBarTheme: TabBarThemeData(
   labelColor: primaryDark,
   unselectedLabelColor: textSecondaryDark,
   indicatorColor: primaryDark,
   indicatorSize: TabBarIndicatorSize.label,
   labelStyle: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
   ),
   unselectedLabelStyle: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
   ),
  ),
  tooltipTheme: TooltipThemeData(
   decoration: BoxDecoration(
    color: textPrimaryDark.withAlpha(230),
    borderRadius: BorderRadius.circular(8.0),
   ),
   textStyle: GoogleFonts.inter(
    color: backgroundDark,
    fontSize: 12,
    fontWeight: FontWeight.w400,
   ),
   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  ),
  snackBarTheme: SnackBarThemeData(
   backgroundColor: textPrimaryDark,
   contentTextStyle: GoogleFonts.inter(
    color: backgroundDark,
    fontSize: 14,
    fontWeight: FontWeight.w400,
   ),
   actionTextColor: secondaryDark,
   behavior: SnackBarBehavior.floating,
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
   ),
   elevation: 4.0,
  ),
  dialogTheme: DialogThemeData(
   backgroundColor: surfaceDark,
   elevation: 8.0,
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
   ),
   titleTextStyle: GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimaryDark,
   ),
   contentTextStyle: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimaryDark,
   ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
   backgroundColor: surfaceDark,
   elevation: 8.0,
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
     top: Radius.circular(20.0),
    ),
   ),
  ),
 );

 /// Light theme text styles using Inter and JetBrains Mono
 static TextTheme _buildLightTextTheme() {
  return TextTheme(
   // Display styles for large headings
   displayLarge: GoogleFonts.inter(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    color: textPrimaryLight,
    letterSpacing: -0.25,
   ),
   displayMedium: GoogleFonts.inter(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    color: textPrimaryLight,
   ),
   displaySmall: GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: textPrimaryLight,
   ),

   // Headline styles for section headers
   headlineLarge: GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: textPrimaryLight,
   ),
   headlineMedium: GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimaryLight,
   ),
   headlineSmall: GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimaryLight,
   ),

   // Title styles for cards and components
   titleLarge: GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textPrimaryLight,
   ),
   titleMedium: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimaryLight,
    letterSpacing: 0.15,
   ),
   titleSmall: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimaryLight,
    letterSpacing: 0.1,
   ),

   // Body text for consultation content
   bodyLarge: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimaryLight,
    letterSpacing: 0.5,
   ),
   bodyMedium: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimaryLight,
    letterSpacing: 0.25,
   ),
   bodySmall: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondaryLight,
    letterSpacing: 0.4,
   ),

   // Label styles for UI elements
   labelLarge: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimaryLight,
    letterSpacing: 0.1,
   ),
   labelMedium: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondaryLight,
    letterSpacing: 0.5,
   ),
   labelSmall: GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: textSecondaryLight,
    letterSpacing: 0.5,
   ),
  );
 }

 /// Dark theme text styles
 static TextTheme _buildDarkTextTheme() {
  return TextTheme(
   displayLarge: GoogleFonts.inter(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    color: textPrimaryDark,
    letterSpacing: -0.25,
   ),
   displayMedium: GoogleFonts.inter(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    color: textPrimaryDark,
   ),
   displaySmall: GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: textPrimaryDark,
   ),
   headlineLarge: GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: textPrimaryDark,
   ),
   headlineMedium: GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimaryDark,
   ),
   headlineSmall: GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimaryDark,
   ),
   titleLarge: GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textPrimaryDark,
   ),
   titleMedium: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimaryDark,
    letterSpacing: 0.15,
   ),
   titleSmall: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimaryDark,
    letterSpacing: 0.1,
   ),
   bodyLarge: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimaryDark,
    letterSpacing: 0.5,
   ),
   bodyMedium: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimaryDark,
    letterSpacing: 0.25,
   ),
   bodySmall: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondaryDark,
    letterSpacing: 0.4,
   ),
   labelLarge: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimaryDark,
    letterSpacing: 0.1,
   ),
   labelMedium: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondaryDark,
    letterSpacing: 0.5,
   ),
   labelSmall: GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: textSecondaryDark,
    letterSpacing: 0.5,
   ),
  );
 }

 /// Helper method to get monospace text style for numerical data
 static TextStyle getMonospaceStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
 }) {
  return GoogleFonts.jetBrainsMono(
   fontSize: fontSize,
   fontWeight: fontWeight,
   color: color,
  );
 }

 /// Helper method to get success color based on theme brightness
 static Color getSuccessColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? successLight
      : successDark;
 }

 /// Helper method to get warning color based on theme brightness
 static Color getWarningColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? warningLight
      : warningDark;
 }

 /// Helper method to get accent color based on theme brightness
 static Color getAccentColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? accentLight
      : accentDark;
 }
}
