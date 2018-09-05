import 'package:language_pal/models/model.dart';
import 'package:language_pal/models/user.dart';

class FlashcardModel extends Model {
  String text;
  String translation;
  String sentence;
  String definition;
  UserModel creator;
  String soundPath;
  String sentenceSoundPath;

  FlashcardModel({this.text, this.sentence, this.definition, this.creator, this.translation}) : super.fromMap(null);

  FlashcardModel.fromMap(Map<String, dynamic> map) : super.fromMap(map);

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'sentence': sentence,
      'definition': definition,
      'translation': translation,
      'sound_path': soundPath,
      'sentence_sound_path': sentenceSoundPath,
      'creator': creator?.toMap(),
    }..addAll(super.toMap());
  }

  Map<String, dynamic> toMapToUpload() {
    var map = super.toMapToUpload();
    map.remove('sound_path');
    map.remove('sentence_sound_path');
    map.remove('creator');
    return map;
  }

  FlashcardModel mergeMap(Map<String, dynamic> map) {
    if (map == null) {
      return this;
    }
    super.mergeMap(map);
    text = map['text'] ?? text;
    sentence = map['sentence'] ?? sentence;
    definition = map['definition'] ?? definition;
    soundPath = map['sound_path'] ?? soundPath;
    sentenceSoundPath = map['sentence_sound_path'] ?? sentenceSoundPath;
    translation = map['translation'] ?? translation;
    creator = map['creator'] ?? creator;
    creator = map.containsKey('creator') ? UserModel.fromMap(map['creator']) : creator;
    return this;
  }
}
