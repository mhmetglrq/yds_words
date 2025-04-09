
import '../../../../../core/resources/data_state.dart';
import '../../../../../core/usecase/future_usecase.dart';
import '../../repositories/question_repository.dart';

class SpeakWordUsecase extends FutureUseCase<DataState<void>, String> {
  final QuestionRepository _repository;

  SpeakWordUsecase(this._repository);
  @override
  Future<DataState<void>> call({String? params}) {
    return _repository.speakWord(params ?? "");
  }
}
