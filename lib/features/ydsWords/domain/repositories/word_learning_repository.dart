import '../../../../core/resources/data_state.dart';
import '../entities/word_entity.dart';

abstract class WordLearningRepository {
  Future<DataState<void>> learnWord(WordEntity word);
  Future<DataState<List<WordEntity>>> getLearnedWords();
  Future<DataState<void>> deleteLearnedWord(WordEntity word);
  Future<DataState<void>> deleteAllLearnedWords();
  Future<DataState<List<WordEntity>>> getWords();
  Future<DataState<void>> speakWord(String word);
}
