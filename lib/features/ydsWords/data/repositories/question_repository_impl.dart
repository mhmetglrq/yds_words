import 'package:yds_words/core/errors/app_exception.dart';
import 'package:yds_words/core/resources/data_state.dart';

import '../../domain/entities/test_question_entity.dart';
import '../../domain/repositories/question_repository.dart';
import '../dataSources/local/hive_database_service.dart';
import '../dataSources/local/text_to_speech_service.dart';
import '../models/test_question_model.dart';
import '../models/word_model.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final HiveDatabaseService _hiveDatabaseService;

  final TextToSpeechService _ttsService;
  final String _learnedWordsBoxName = 'learnedWords'; // Sabit bir box adı
  final String _wordsBoxName = 'words';

  QuestionRepositoryImpl(
      this._hiveDatabaseService, this._ttsService); // Sabit bir box adı
  @override
  Future<DataState<List<TestQuestionEntity>>> generateTestQuestions(
      TestQuestionType type) async {
    try {
      final words = await _hiveDatabaseService.getAllData<WordModel>(
        _wordsBoxName,
        closeBoxAfterOperation: true,
      );

      final learnedWords = await _hiveDatabaseService.getAllData<WordModel>(
        _learnedWordsBoxName,
        closeBoxAfterOperation: true,
      );

      final selectedLearnedWords = learnedWords.length > 10
          ? (learnedWords.toList()..shuffle()).take(10).toList()
          : learnedWords;

      late final List<TestQuestionModel> questions;

      switch (type) {
        case TestQuestionType.meaning:
          questions = _createMeaningQuestions(selectedLearnedWords, words);
          break;
        case TestQuestionType.sentenceFill:
          questions = _createSentenceFillQuestions(selectedLearnedWords, words);
          break;
        case TestQuestionType.sentenceTranslation:
          questions =
              _createSentenceTranslationQuestions(selectedLearnedWords, words);
          break;
      }

      return DataSuccess(
        questions
            .map((e) => TestQuestionEntity(
                  questionText: e.questionText,
                  options: e.options,
                  correctIndex: e.correctIndex,
                  type: e.type,
                ))
            .toList(),
      );
    } catch (e) {
      return DataFailed(
        exception: GenericException("Failed to create questions:$e"),
      );
    }
  }

  @override
  Future<DataState<void>> speakWord(String word) async {
    try {
      // Kelimeyi seslendirmek için TTS servisini kullanıyoruz
      await _ttsService.setLanguage('en-US');
      await _ttsService.speak(word);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(
        exception: GenericException('Failed to speak word: $e'),
      );
    }
  }

  List<TestQuestionModel> _createMeaningQuestions(
      List<WordModel> learnedWords, List<WordModel> words) {
    return learnedWords.map((learnedWord) {
      final correctAnswer = learnedWord.translation;
      final wrongOptions = words
          .where((w) => w.translation != correctAnswer)
          .toList()
        ..shuffle();
      final options = [
        correctAnswer,
        ...wrongOptions.take(3).map((w) => w.translation),
      ]..shuffle();
      final correctIndex = options.indexOf(correctAnswer);
      return TestQuestionModel(
        questionText: learnedWord.word,
        options: options,
        correctIndex: correctIndex,
        type: TestQuestionType.meaning,
      );
    }).toList();
  }

  List<TestQuestionModel> _createSentenceFillQuestions(
      List<WordModel> learnedWords, List<WordModel> words) {
    return learnedWords
        .where((w) => w.exampleSentence.contains(w.word))
        .map((learnedWord) {
      final blankSentence =
          learnedWord.exampleSentence.replaceFirst(learnedWord.word, '_____');
      final correctAnswer = learnedWord.word;
      final wrongOptions = words.where((w) => w.word != correctAnswer).toList()
        ..shuffle();
      final options = [
        correctAnswer,
        ...wrongOptions.take(3).map((w) => w.word),
      ]..shuffle();
      final correctIndex = options.indexOf(correctAnswer);
      return TestQuestionModel(
        questionText: blankSentence,
        options: options,
        correctIndex: correctIndex,
        type: TestQuestionType.sentenceFill,
      );
    }).toList();
  }

  List<TestQuestionModel> _createSentenceTranslationQuestions(
      List<WordModel> learnedWords, List<WordModel> words) {
    return learnedWords.map((learnedWord) {
      final correctAnswer = learnedWord.exampleTranslation;
      final questionText = learnedWord.exampleSentence;
      final wrongOptions = words
          .where((w) => w.exampleTranslation != correctAnswer)
          .map((w) => w.exampleTranslation)
          .where((t) => t.isNotEmpty)
          .toSet()
          .toList()
        ..shuffle();
      final options = [
        correctAnswer,
        ...wrongOptions.take(3),
      ]..shuffle();
      final correctIndex = options.indexOf(correctAnswer);
      return TestQuestionModel(
        questionText: questionText,
        options: options,
        correctIndex: correctIndex,
        type: TestQuestionType.sentenceTranslation,
      );
    }).toList();
  }
}
