import '../../../../../core/resources/data_state.dart';
import '../../../../../core/usecase/future_usecase.dart';
import '../../entities/test_question_entity.dart';
import '../../repositories/question_repository.dart';

class GenerateTestQuestionsUsecase extends FutureUseCase<
    DataState<List<TestQuestionEntity>>, TestQuestionType> {
  final QuestionRepository _repository;
  GenerateTestQuestionsUsecase(
    this._repository,
  );

  @override
  Future<DataState<List<TestQuestionEntity>>> call({TestQuestionType? params}) {
    return _repository.generateTestQuestions(params!);
  }
}
