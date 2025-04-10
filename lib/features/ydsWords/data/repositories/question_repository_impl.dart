import 'package:yds_words/core/errors/app_exception.dart';
import 'package:yds_words/core/resources/data_state.dart';
import 'dart:math';

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
    final random = Random();
    return learnedWords.map((learnedWord) {
      final isEnglishToTurkish = random.nextBool();
      final correctAnswer =
          isEnglishToTurkish ? learnedWord.translation : learnedWord.word;
      final questionText =
          isEnglishToTurkish ? learnedWord.word : learnedWord.translation;

      final wrongOptions = words
          .where((w) =>
              (isEnglishToTurkish ? w.translation : w.word) != correctAnswer)
          .toList()
        ..shuffle();

      final options = [
        correctAnswer,
        ...wrongOptions
            .take(3)
            .map((w) => isEnglishToTurkish ? w.translation : w.word),
      ]..shuffle();

      final correctIndex = options.indexOf(correctAnswer);

      return TestQuestionModel(
        questionText: questionText,
        options: options,
        correctIndex: correctIndex,
        type: TestQuestionType.meaning,
      );
    }).toList();
  }

  List<TestQuestionModel> _createSentenceFillQuestions(
      List<WordModel> learnedWords, List<WordModel> words) {
    final random = Random();
    return learnedWords
        .where((w) => w.exampleSentence.contains(w.word))
        .map((learnedWord) {
      final isEnglishToBlank = random.nextBool();

      final questionText = isEnglishToBlank
          ? learnedWord.exampleSentence.replaceFirst(learnedWord.word, '_____')
          : learnedWord.exampleTranslation
              .replaceFirst(learnedWord.translation, '_____');

      final correctAnswer =
          isEnglishToBlank ? learnedWord.word : learnedWord.translation;

      final wrongOptions = words
          .where((w) =>
              (isEnglishToBlank ? w.word : w.translation) != correctAnswer)
          .toList()
        ..shuffle();

      final options = [
        correctAnswer,
        ...wrongOptions
            .take(3)
            .map((w) => isEnglishToBlank ? w.word : w.translation),
      ]..shuffle();

      final correctIndex = options.indexOf(correctAnswer);

      return TestQuestionModel(
        questionText: questionText,
        options: options,
        correctIndex: correctIndex,
        type: TestQuestionType.sentenceFill,
      );
    }).toList();
  }

  List<TestQuestionModel> _createSentenceTranslationQuestions(
      List<WordModel> learnedWords, List<WordModel> words) {
    final random = Random();
    return learnedWords.map((learnedWord) {
      final isEnglishToTurkish = random.nextBool();
      final correctAnswer = isEnglishToTurkish
          ? learnedWord.exampleTranslation
          : learnedWord.exampleSentence;
      final questionText = isEnglishToTurkish
          ? learnedWord.exampleSentence
          : learnedWord.exampleTranslation;

      final wrongOptions = words
          .map((w) =>
              isEnglishToTurkish ? w.exampleTranslation : w.exampleSentence)
          .where((opt) => opt.isNotEmpty && opt != correctAnswer)
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
