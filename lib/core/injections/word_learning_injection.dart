import 'package:get_it/get_it.dart';
import 'package:yds_words/features/ydsWords/domain/usecases/wordLearning/delete_all_learned_words_usecase.dart';
import 'package:yds_words/features/ydsWords/domain/usecases/wordLearning/delete_learned_word_usecase.dart';
import 'package:yds_words/features/ydsWords/domain/usecases/wordLearning/get_learned_words_usecase.dart';
import 'package:yds_words/features/ydsWords/domain/usecases/wordLearning/get_words_usecase.dart';
import 'package:yds_words/features/ydsWords/domain/usecases/wordLearning/learn_word_usecase.dart';

import '../../features/ydsWords/data/repositories/word_learning_repository_impl.dart';
import '../../features/ydsWords/domain/repositories/word_learning_repository.dart';
import '../../features/ydsWords/domain/usecases/wordLearning/speak_word_usecase.dart';
import '../../features/ydsWords/presentation/blocs/wordLearning/word_learning_bloc.dart';

final sl = GetIt.instance;

class WordLearningInjection {
  static void init() {
    // Repositories
    sl.registerLazySingleton<WordLearningRepository>(
        () => WordLearningRepositoryImpl(sl(), sl()));

    // Usecases
    sl.registerLazySingleton<DeleteAllLearnedWordsUsecase>(
        () => DeleteAllLearnedWordsUsecase(sl()));
    sl.registerLazySingleton<DeleteLearnedWordUsecase>(
        () => DeleteLearnedWordUsecase(sl()));
    sl.registerLazySingleton<GetLearnedWordsUsecase>(
        () => GetLearnedWordsUsecase(sl()));
    sl.registerLazySingleton<GetWordsUseCase>(() => GetWordsUseCase(sl()));
    sl.registerLazySingleton<LearnWordUsecase>(() => LearnWordUsecase(sl()));
    sl.registerLazySingleton<SpeakWordUsecase>(() => SpeakWordUsecase(sl()));

    // Bloc
    sl.registerFactory<WordLearningBloc>(() => WordLearningBloc(
          deleteAllLearnedWordsUsecase: sl(),
          deleteLearnedWordUsecase: sl(),
          getLearnedWordsUsecase: sl(),
          getWordsUseCase: sl(),
          learnWordUsecase: sl(),
          speakWordUsecase: sl(),
        ));
  }

  static void dispose() {
    sl.unregister<WordLearningBloc>();
    sl.unregister<DeleteAllLearnedWordsUsecase>();
    sl.unregister<DeleteLearnedWordUsecase>();
    sl.unregister<GetLearnedWordsUsecase>();
    sl.unregister<GetWordsUseCase>();
    sl.unregister<LearnWordUsecase>();
    sl.unregister<SpeakWordUsecase>();
    sl.unregister<WordLearningRepository>();
  }
}
