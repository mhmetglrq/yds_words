import '../../../../../core/resources/data_state.dart';
import '../../../../../core/usecase/future_usecase.dart';
import '../../repositories/word_learning_repository.dart';

class DeleteAllLearnedWordsUsecase
    extends FutureUseCase<DataState<void>, void> {
  final WordLearningRepository _repository;

  DeleteAllLearnedWordsUsecase(this._repository);

  @override
  Future<DataState<void>> call({void params}) {
    return _repository.deleteAllLearnedWords();
  }
}
