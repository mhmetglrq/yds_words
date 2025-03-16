import 'package:hive/hive.dart';


@HiveType(typeId: 1)
abstract class WordEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String word;
  @HiveField(2)
  final String translation;
  @HiveField(3)
  final String type;
  @HiveField(4)
  final String exampleSentence;
  @HiveField(5)
  final String exampleTranslation;


  WordEntity({
    required this.id,
    required this.word,
    required this.translation,
    required this.type,
    required this.exampleSentence,
    required this.exampleTranslation,
  });
}
