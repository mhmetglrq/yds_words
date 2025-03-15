import '../../../../../core/resources/data_state.dart';
import '../../../../../core/usecase/future_usecase.dart';
import '../../repositories/word_learning_repository.dart';

class SpeakWordUsecase extends FutureUseCase<DataState<void>, String> {
  final WordLearningRepository _repository;

  SpeakWordUsecase(this._repository);
  @override
  Future<DataState<void>> call({String? params}) {
    return _repository.speakWord(params ?? "");
  }
}
