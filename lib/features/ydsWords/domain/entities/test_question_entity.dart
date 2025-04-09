import 'package:equatable/equatable.dart';

enum TestQuestionType {
  meaning, // Kelime anlamı: İngilizce → Türkçe veya Türkçe → İngilizce
  sentenceFill, // Cümle içinde boşluğu doldur
  sentenceTranslation, // Cümleyi çevir
}

class TestQuestionEntity extends Equatable {
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final TestQuestionType type;

  const TestQuestionEntity({
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.type,
  });

  @override
  List<Object> get props => [questionText, options, correctIndex, type];
}
