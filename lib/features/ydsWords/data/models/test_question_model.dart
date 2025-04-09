import '../../domain/entities/test_question_entity.dart';

class TestQuestionModel extends TestQuestionEntity {
  const TestQuestionModel(
      {required super.questionText,
      required super.options,
      required super.correctIndex,
      required super.type});

  factory TestQuestionModel.fromEntity(TestQuestionEntity entity) =>
      TestQuestionModel(
          questionText: entity.questionText,
          options: entity.options,
          correctIndex: entity.correctIndex,
          type: entity.type);
}
