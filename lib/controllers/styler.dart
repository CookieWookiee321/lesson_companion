import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lesson_companion/models/pdf_document/pdf_text.dart';
import 'package:lesson_companion/models/pdf_document/pdf_textspan.dart';
import 'package:lesson_companion/models/styling/pdf_lexer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf_widj;

class Styler {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFB52706),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFDAD3),
    onPrimaryContainer: Color(0xFF3D0600),
    secondary: Color(0xFF77574F),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFDAD3),
    onSecondaryContainer: Color(0xFF2C1510),
    tertiary: Color(0xFF6D5D2E),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFF8E0A6),
    onTertiaryContainer: Color(0xFF241A00),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFFFBFF),
    onBackground: Color(0xFF201A19),
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF201A19),
    surfaceVariant: Color(0xFFF5DDD8),
    onSurfaceVariant: Color(0xFF534340),
    outline: Color(0xFF85736F),
    onInverseSurface: Color(0xFFFBEEEB),
    inverseSurface: Color(0xFF362F2D),
    inversePrimary: Color(0xFFFFB4A4),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFB52706),
    outlineVariant: Color(0xFFD8C2BD),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFB4A4),
    onPrimary: Color(0xFF630E00),
    primaryContainer: Color(0xFF8C1800),
    onPrimaryContainer: Color(0xFFFFDAD3),
    secondary: Color(0xFFE7BDB4),
    onSecondary: Color(0xFF442A24),
    secondaryContainer: Color(0xFF5D3F39),
    onSecondaryContainer: Color(0xFFFFDAD3),
    tertiary: Color(0xFFDBC58C),
    onTertiary: Color(0xFF3C2F04),
    tertiaryContainer: Color(0xFF544519),
    onTertiaryContainer: Color(0xFFF8E0A6),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF201A19),
    onBackground: Color(0xFFEDE0DD),
    surface: Color(0xFF201A19),
    onSurface: Color(0xFFEDE0DD),
    surfaceVariant: Color(0xFF534340),
    onSurfaceVariant: Color(0xFFD8C2BD),
    outline: Color(0xFFA08C88),
    onInverseSurface: Color(0xFF201A19),
    inverseSurface: Color(0xFFEDE0DD),
    inversePrimary: Color(0xFFB52706),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFFFB4A4),
    outlineVariant: Color(0xFF534340),
    scrim: Color(0xFF000000),
  );
}

enum PdfSection { h1, h2, h3, body, footer }

class PdfStyler {
  static PdfColor parseTextColour(String input) {
    //col<this is the text :: colour>
    final colour = input.substring(0, input.length - 1).split("::")[1].trim();

    switch (colour) {
      case "grey":
      case "silver":
        return PdfColors.grey;
      case "green":
        return PdfColors.green;
      case "orange":
        return PdfColors.orange;
      case "purple":
        return PdfColors.purple;
      case "blue":
        return PdfColors.blue;
      case "red":
        return PdfColors.red;
      default:
        return PdfColors.black;
    }
  }
}
