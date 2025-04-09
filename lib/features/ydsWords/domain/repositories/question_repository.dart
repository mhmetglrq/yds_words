import 'package:yds_words/features/ydsWords/domain/entities/test_question_entity.dart';

import '../../../../core/resources/data_state.dart';

abstract class QuestionRepository {
  Future<DataState<List<TestQuestionEntity>>> generateTestQuestions(
      TestQuestionType type);
  Future<DataState<void>> speakWord(String word);
}
