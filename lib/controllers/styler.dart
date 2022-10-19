import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf_widj;

import '../models/pdf_document/pdf_document.dart';

class Styler {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF006D3A),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF99F6B5),
    onPrimaryContainer: Color(0xFF00210E),
    secondary: Color(0xFF4F6353),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD2E8D4),
    onSecondaryContainer: Color(0xFF0D1F13),
    tertiary: Color(0xFF3A646F),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFBEEAF6),
    onTertiaryContainer: Color(0xFF001F26),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFBFDF8),
    onBackground: Color(0xFF191C19),
    surface: Color(0xFFFBFDF8),
    onSurface: Color(0xFF191C19),
    surfaceVariant: Color(0xFFDDE5DB),
    onSurfaceVariant: Color(0xFF414942),
    outline: Color(0xFF717971),
    onInverseSurface: Color(0xFFF0F1EC),
    inverseSurface: Color(0xFF2E312E),
    inversePrimary: Color(0xFF7DDA9A),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF006D3A),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF7DDA9A),
    onPrimary: Color(0xFF00391C),
    primaryContainer: Color(0xFF00522B),
    onPrimaryContainer: Color(0xFF99F6B5),
    secondary: Color(0xFFB6CCB8),
    onSecondary: Color(0xFF223527),
    secondaryContainer: Color(0xFF384B3C),
    onSecondaryContainer: Color(0xFFD2E8D4),
    tertiary: Color(0xFFA2CEDA),
    onTertiary: Color(0xFF02363F),
    tertiaryContainer: Color(0xFF214C57),
    onTertiaryContainer: Color(0xFFBEEAF6),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF191C19),
    onBackground: Color(0xFFE1E3DE),
    surface: Color(0xFF191C19),
    onSurface: Color(0xFFE1E3DE),
    surfaceVariant: Color(0xFF414942),
    onSurfaceVariant: Color(0xFFC1C9BF),
    outline: Color(0xFF8B938A),
    onInverseSurface: Color(0xFF191C19),
    inverseSurface: Color(0xFFE1E3DE),
    inversePrimary: Color(0xFF006D3A),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF7DDA9A),
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
