import 'package:hive/hive.dart';
import 'package:yds_words/features/ydsWords/domain/entities/word_entity.dart';

part 'word_model.g.dart';

@HiveType(typeId: 2)
class WordModel extends WordEntity {
  WordModel({
    required super.id,
    required super.word,
    required super.translation,
    required super.type,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      word: json['word'],
      translation: json['translation'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'translation': translation,
      'type': type,
    };
  }

  factory WordModel.fromEntity(WordEntity entity) {
    return WordModel(
      id: entity.id,
      word: entity.word,
      translation: entity.translation,
      type: entity.type,
    );
  }

  WordModel copyWith({
    String? id,
    String? word,
    String? translation,
    String? type,
  }) {
    return WordModel(
      id: id ?? this.id,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      type: type ?? this.type,
    );
  }
}
