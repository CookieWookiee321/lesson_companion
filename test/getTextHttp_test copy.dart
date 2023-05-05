import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lesson_companion/controllers/styling/companion_lexer.dart';

import 'package:test/test.dart';

void main() {
  final textSpanList =
      CompanionLexer.parseText("**Reading** [10] //*(The Book)*");

  test("Individual spans all correct", () {
    expect(textSpanList.length, 3);
  });
}
