import '../../../../../core/resources/data_state.dart';
import '../../../../../core/usecase/future_usecase.dart';
import '../../entities/word_entity.dart';
import '../../repositories/word_learning_repository.dart';

class DeleteLearnedWordUsecase
    extends FutureUseCase<DataState<void>, WordEntity> {
  final WordLearningRepository _repository;

  DeleteLearnedWordUsecase(this._repository);

  @override
  Future<DataState<void>> call({WordEntity? params}) {
    return _repository.deleteLearnedWord(params!);
  }
}
