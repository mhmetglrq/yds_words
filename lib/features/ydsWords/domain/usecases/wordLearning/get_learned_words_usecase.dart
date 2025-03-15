import '../../../../../core/resources/data_state.dart';
import '../../../../../core/usecase/future_usecase.dart';
import '../../entities/word_entity.dart';
import '../../repositories/word_learning_repository.dart';

class GetLearnedWordsUsecase
    extends FutureUseCase<DataState<List<WordEntity>>, void> {
  final WordLearningRepository _repository;

  GetLearnedWordsUsecase(this._repository);

  @override
  Future<DataState<List<WordEntity>>> call({void params})async {
    return await _repository.getLearnedWords();
  }
}
