import 'package:lesson_companion/models/dictionary/free_dictionary.dart';

class LookUp {
  late final String term;
  late final List<LookUpDetails> details = [];

  LookUp(List<FreeDictionary> freeDictionaryEntries) {
    this.term = freeDictionaryEntries.first.word.toString();

    for (final entry in freeDictionaryEntries) {
      for (final meaning in entry.meanings!) {
        final thisEntry = LookUpDetails();
        final partOfSpeech = meaning.partOfSpeech!;
        final Map<String, String?> defAndEx = {};

        //if details list exists for part of speech, then add to existing obj
        if (details.any((e) => e.partOfSpeech == partOfSpeech)) {
          //get the object
          final deets =
              details.where((e) => e.partOfSpeech == partOfSpeech).single;

          for (final def in meaning.definitions!) {
            deets.definitionsAndExamples[def.definition!] = def.example;
          }
        } else {
          for (final def in meaning.definitions!) {
            defAndEx[def.definition!] = def.example;
          }

          thisEntry.partOfSpeech = partOfSpeech;
          thisEntry.definitionsAndExamples = defAndEx;
          details.add(thisEntry);
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
