import 'package:lesson_companion/models/open_AI_access.dart';

import 'package:test/test.dart';

void main() {
  test("Get text from URL", () async {
    final x = await OpenAiAccess.getDefinition("dog");
    print(x);
    expect(x, "aardvark");
  });
}
