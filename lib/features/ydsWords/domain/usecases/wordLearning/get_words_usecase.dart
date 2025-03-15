import '../../../../../core/resources/data_state.dart';
import '../../../../../core/usecase/future_usecase.dart';
import '../../entities/word_entity.dart';
import '../../repositories/word_learning_repository.dart';

class GetWordsUseCase extends FutureUseCase<DataState<List<WordEntity>>, void> {
  final WordLearningRepository _repository;

  GetWordsUseCase(this._repository);

  @override
  Future<DataState<List<WordEntity>>> call({void params}) {
    return _repository.getWords();
  }
}
