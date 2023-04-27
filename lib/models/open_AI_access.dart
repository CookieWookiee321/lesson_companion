import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class OpenAiAccess {
  static final openAI = OpenAI.instance.build(
      token: "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",
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)));

  static Future<String> getDefinition(String term) async {
    final request = CompleteText(
        prompt:
            'Provide the definition (@d), part of speech (@p), and a simple example sentence (@e) for "dog". It should be in this format: **dog** //pos{@p} || @d // eg{@e}',
        model: Model.kTextDavinci3,
        maxTokens: 200);
    final response = await openAI.onCompletion(request: request);
    return response.toString();
  }
}
