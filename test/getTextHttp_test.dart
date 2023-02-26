import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:test/test.dart';

void main() {
  Future<String> get() async {
    final response = await http
        .get(Uri.parse("http://www.mieliestronk.com/corncob_lowercase.txt"));
    return utf8.decode(response.bodyBytes);
  }

  test("Get text from URL", () async {
    final x = await get();
    expect(x.split("\r\n")[0], "aardvark");
  });
}
