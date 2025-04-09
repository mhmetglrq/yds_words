import 'package:get_it/get_it.dart';
import 'package:yds_words/features/ydsWords/presentation/blocs/question/question_bloc.dart';

import '../../features/ydsWords/data/repositories/question_repository_impl.dart';
import '../../features/ydsWords/domain/repositories/question_repository.dart';
import '../../features/ydsWords/domain/usecases/question/generate_test_questions_usecase.dart';
import '../../features/ydsWords/domain/usecases/question/speak_word_usecase.dart';

final sl = GetIt.instance;

class QuestionInjection {
  static void init() {
    // Repositories
    sl.registerLazySingleton<QuestionRepository>(
        () => QuestionRepositoryImpl(sl(), sl()));

    // Usecases
    sl.registerLazySingleton<GenerateTestQuestionsUsecase>(
        () => GenerateTestQuestionsUsecase(sl()));

    sl.registerLazySingleton<SpeakWordUsecase>(() => SpeakWordUsecase(sl()));
    // Bloc
    sl.registerFactory<QuestionBloc>(() => QuestionBloc(sl()));
  }

  static void dispose() {
    sl.unregister<QuestionBloc>();
    sl.unregister<GenerateTestQuestionsUsecase>();
    sl.unregister<SpeakWordUsecase>();
    sl.unregister<QuestionRepository>();
  }
}
