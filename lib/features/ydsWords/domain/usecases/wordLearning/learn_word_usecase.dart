import 'package:yds_words/core/usecase/future_usecase.dart';
import 'package:yds_words/features/ydsWords/domain/entities/word_entity.dart';

import '../../../../../core/resources/data_state.dart';
import '../../repositories/word_learning_repository.dart';

class LearnWordUsecase extends FutureUseCase<DataState<void>, WordEntity> {
  final WordLearningRepository _repository;

  LearnWordUsecase(this._repository);

  @override
  Future<DataState<void>> call({WordEntity? params}) async {
    return await _repository.learnWord(params!);
  }
}
