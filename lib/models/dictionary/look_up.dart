import 'package:lesson_companion/models/dictionary/free_dictionary.dart';

class NewLanguageLookUp {
  late final String term;
  late final List<LookUpDetails> lookUpDetails = [];

  NewLanguageLookUp(List<FreeDictionary> freeDictionaryEntries) {
    this.term = freeDictionaryEntries.first.word.toString();

    for (final entry in freeDictionaryEntries) {
      for (final meaning in entry.meanings!) {
        final thisEntry = LookUpDetails();
        final partOfSpeech = meaning.partOfSpeech!;
        final Map<String, String?> defAndEx = {};

        //if details list exists for part of speech, then add to existing obj
        if (lookUpDetails.any((e) => e.partOfSpeech == partOfSpeech)) {
          //get the object
          final deets =
              lookUpDetails.where((e) => e.partOfSpeech == partOfSpeech).single;

          for (final def in meaning.definitions!) {
            deets.definitionsAndExamples[def.definition!] = def.example;
          }
        } else {
          for (final def in meaning.definitions!) {
            defAndEx[def.definition!] = def.example;
          }

          thisEntry.partOfSpeech = partOfSpeech;
          thisEntry.definitionsAndExamples = defAndEx;
          lookUpDetails.add(thisEntry);
        }
      }
    }
  }
}

class LookUpDetails {
  late final String partOfSpeech;
  late final Map<String, String?> definitionsAndExamples;

  LookUpDetails();
}

class LookUpReturn {
  final String term;
  String? partOfSpeech;
  String? definition;
  String? example;

  LookUpReturn(this.term);
}
