import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf_widj;

import '../models/pdf_document/pdf_text.dart';

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
  static Future<pdf_widj.RichText> styleText(
      {required PdfSection section,
      required PdfText pdfText,
      ColorOption color = ColorOption.regular,
      bool isBold = false,
      bool isItalic = false,
      bool isUnderlined = false}) async {
    final List<pdf_widj.TextSpan> inlineSpan = [];
    final pdf_widj.RichText output;
    final double baseHeight;
    final double subHeight;

    switch (section) {
      case PdfSection.h1:
        baseHeight = 20;
        subHeight = 16;
        break;
      case PdfSection.h2:
        baseHeight = 16;
        subHeight = 13;
        break;
      case PdfSection.h3:
        baseHeight = 13;
        subHeight = 11;
        break;
      case PdfSection.body:
        baseHeight = 11;
        subHeight = 9;
        break;
      case PdfSection.footer:
        baseHeight = 10;
        subHeight = 8;
        break;
    }

    for (final x in pdfText.components) {
      pdf_widj.TextSpan outputSpan;

      PdfColor thisColor;
      switch (x.color) {
        case ColorOption.purple:
          thisColor = PdfColors.purple800;
          break;
        case ColorOption.orange:
          thisColor = PdfColors.orange600;
          break;
        case ColorOption.green:
          thisColor = PdfColors.green600;
          break;
        case ColorOption.regular:
          thisColor = PdfColors.black;
          break;
        case ColorOption.silver:
          thisColor = PdfColors.grey600;
          break;
      }

      final thisFont;
      if (x.bold && x.italic) {
        thisFont = pdf_widj.Font.ttf(
          await rootBundle.load("lib/assets/Andika-BoldItalic.ttf"),
        );
      } else if (x.bold) {
        thisFont = pdf_widj.Font.ttf(
          await rootBundle.load("lib/assets/Andika-Bold.ttf"),
        );
      } else if (x.italic) {
        thisFont = pdf_widj.Font.ttf(
          await rootBundle.load("lib/assets/Andika-Italic.ttf"),
        );
      } else {
        thisFont = pdf_widj.Font.ttf(
          await rootBundle.load("lib/assets/Andika-Regular.ttf"),
        );
      }

      switch (x.color) {
        case ColorOption.regular:
          if (section == PdfSection.h1 ||
              section == PdfSection.h2 ||
              section == PdfSection.h3) {
            thisColor = PdfColors.blueGrey800;
            isBold = true;
          }

          outputSpan = pdf_widj.TextSpan(
              text: x.text,
              style: pdf_widj.TextStyle(
                  fontSize: baseHeight,
                  color: thisColor,
                  fontWeight: x.bold
                      ? pdf_widj.FontWeight.bold
                      : pdf_widj.FontWeight.normal,
                  fontStyle: x.italic
                      ? pdf_widj.FontStyle.italic
                      : pdf_widj.FontStyle.normal,
                  font: thisFont,
                  decoration:
                      x.underlined ? pdf_widj.TextDecoration.underline : null));
          break;
        default:
          outputSpan = pdf_widj.TextSpan(
              text: x.text,
              style: pdf_widj.TextStyle(
                  fontSize: subHeight,
                  color: thisColor,
                  fontWeight: x.bold
                      ? pdf_widj.FontWeight.bold
                      : pdf_widj.FontWeight.normal,
                  fontStyle: x.italic
                      ? pdf_widj.FontStyle.italic
                      : pdf_widj.FontStyle.normal,
                  font: thisFont,
                  decoration:
                      x.underlined ? pdf_widj.TextDecoration.underline : null));
          break;
      }

      inlineSpan.add(outputSpan);
    }

    output = pdf_widj.RichText(text: pdf_widj.TextSpan(children: inlineSpan));
    return output;
  }
}
