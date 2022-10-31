import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf_widj;

import '../models/pdf_document/pdf_document.dart';

class Styler {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF765A00),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFDF95),
    onPrimaryContainer: Color(0xFF251A00),
    secondary: Color(0xFF6A5D3F),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFF3E1BB),
    onSecondaryContainer: Color(0xFF231A04),
    tertiary: Color(0xFF486548),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFCAEBC7),
    onTertiaryContainer: Color(0xFF05210A),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFFFBFF),
    onBackground: Color(0xFF1E1B16),
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF1E1B16),
    surfaceVariant: Color(0xFFECE1CF),
    onSurfaceVariant: Color(0xFF4D4639),
    outline: Color(0xFF7E7667),
    onInverseSurface: Color(0xFFF7F0E7),
    inverseSurface: Color(0xFF33302A),
    inversePrimary: Color(0xFFF4BF1C),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF765A00),
    outlineVariant: Color(0xFFCFC5B4),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFF4BF1C),
    onPrimary: Color(0xFF3E2E00),
    primaryContainer: Color(0xFF594400),
    onPrimaryContainer: Color(0xFFFFDF95),
    secondary: Color(0xFFD6C5A0),
    onSecondary: Color(0xFF3A2F15),
    secondaryContainer: Color(0xFF51452A),
    onSecondaryContainer: Color(0xFFF3E1BB),
    tertiary: Color(0xFFAECFAC),
    onTertiary: Color(0xFF1B361D),
    tertiaryContainer: Color(0xFF314D32),
    onTertiaryContainer: Color(0xFFCAEBC7),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1E1B16),
    onBackground: Color(0xFFE9E1D9),
    surface: Color(0xFF1E1B16),
    onSurface: Color(0xFFE9E1D9),
    surfaceVariant: Color(0xFF4D4639),
    onSurfaceVariant: Color(0xFFCFC5B4),
    outline: Color(0xFF989080),
    onInverseSurface: Color(0xFF1E1B16),
    inverseSurface: Color(0xFFE9E1D9),
    inversePrimary: Color(0xFF765A00),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFF4BF1C),
    outlineVariant: Color(0xFF4D4639),
    scrim: Color(0xFF000000),
  );
}

enum PdfSection { h1, h2, h3, body, footer }

class StylerMethods {
  static Future<pdf_widj.TextStyle> getTextStyle(
      PdfSection section, PdfTextType type) async {
    switch (section) {
      case PdfSection.h1:
        switch (type) {
          case PdfTextType.sub:
            return pdf_widj.TextStyle(
                color: PdfColors.grey600,
                fontSize: 16.0,
                font: pdf_widj.Font.ttf(await rootBundle
                    .load("lib/assets/IBMPlexSansKR-SemiBold.ttf")));
          default:
            return pdf_widj.TextStyle(
                color: PdfColors.blueGrey800,
                fontSize: 20.0,
                font: pdf_widj.Font.ttf(await rootBundle
                    .load("lib/assets/IBMPlexSansKR-Bold.ttf")));
        }
      case PdfSection.h2:
        switch (type) {
          case PdfTextType.sub:
            return pdf_widj.TextStyle(
                color: PdfColors.grey600,
                fontSize: 13.0,
                font: pdf_widj.Font.ttf(await rootBundle
                    .load("lib/assets/IBMPlexSansKR-SemiBold.ttf")));
          default:
            return pdf_widj.TextStyle(
                color: PdfColors.blueGrey700,
                fontSize: 16.0,
                font: pdf_widj.Font.ttf(await rootBundle
                    .load("lib/assets/IBMPlexSansKR-Regular.ttf")));
        }
      case PdfSection.h3:
        switch (type) {
          case PdfTextType.sub:
            return pdf_widj.TextStyle(
                color: PdfColors.grey600,
                fontSize: 11.0,
                font: pdf_widj.Font.ttf(await rootBundle
                    .load("lib/assets/IBMPlexSansKR-SemiBold.ttf")));
          default:
            return pdf_widj.TextStyle(
                color: PdfColors.blueGrey800,
                fontSize: 13.0,
                font: pdf_widj.Font.ttf(await rootBundle
                    .load("lib/assets/IBMPlexSansKR-Bold.ttf")));
        }
      case PdfSection.body:
        switch (type) {
          case PdfTextType.question:
            return pdf_widj.TextStyle(
                color: PdfColors.blue600,
                fontSize: 10.0,
                fontStyle: pdf_widj.FontStyle.italic,
                font: pdf_widj.Font.ttf(await rootBundle
                    .load("lib/assets/IBMPlexSansKR-Regular.ttf")));
          case PdfTextType.base:
            return pdf_widj.TextStyle(
                color: PdfColors.black,
                fontSize: 11.0,
                font: pdf_widj.Font.ttf(await rootBundle
                    .load("lib/assets/IBMPlexSansKR-Regular.ttf")));
          case PdfTextType.sub:
            return pdf_widj.TextStyle(
                color: PdfColors.grey600,
                fontSize: 9.0,
                font: pdf_widj.Font.ttf(await rootBundle
                    .load("lib/assets/IBMPlexSansKR-SemiBold.ttf")));
          case PdfTextType.example:
            return pdf_widj.TextStyle(
                color: PdfColors.green800,
                fontSize: 10.0,
                font: pdf_widj.Font.ttf(await rootBundle
                    .load("lib/assets/IBMPlexSansKR-SemiBold.ttf")));
          case PdfTextType.info:
            return pdf_widj.TextStyle(
                color: PdfColors.orange800,
                fontSize: 10.0,
                font: pdf_widj.Font.ttf(await rootBundle
                    .load("lib/assets/IBMPlexSansKR-Regular.ttf")));
        }
      case PdfSection.footer:
        return pdf_widj.TextStyle(
            fontSize: 9.0,
            color: PdfColors.blueGrey600,
            fontStyle: pdf_widj.FontStyle.italic,
            font: pdf_widj.Font.ttf(
                await rootBundle.load("lib/assets/IBMPlexSansKR-Regular.ttf")));
    }
  }
}
