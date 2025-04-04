import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:yds_words/core/resources/data_state.dart';
import 'package:yds_words/features/ydsWords/data/dataSources/local/hive_database_service.dart';
import 'package:yds_words/features/ydsWords/domain/entities/word_entity.dart';
import '../../../../config/utilities/enums/asset_enum.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/repositories/word_learning_repository.dart';
import '../dataSources/local/text_to_speech_service.dart';
import '../models/word_model.dart'; // WordModel'ı import ediyoruz

class WordLearningRepositoryImpl implements WordLearningRepository {
  final HiveDatabaseService _hiveDatabaseService;
  final TextToSpeechService _ttsService;
  final String _learnedWordsBoxName = 'learnedWords'; // Sabit bir box adı
  final String _wordsBoxName = 'words'; // Sabit bir box adı

  WordLearningRepositoryImpl(this._hiveDatabaseService, this._ttsService);

  @override
  Future<DataState<void>> deleteAllLearnedWords() async {
    try {
      // Tüm öğrenilmiş kelimeleri silmek için box'ı temizliyoruz
      await _hiveDatabaseService.clearBox<WordModel>(
        _learnedWordsBoxName,
      );
      return const DataSuccess(null);
    } on HiveError catch (e) {
      return DataFailed(
          exception:
              HiveExceptionCustom('Failed to delete all learned words: $e'));
    } catch (e) {
      return DataFailed(
        exception: GenericException(
            'Unexpected error while deleting all learned words: $e'),
      );
    }
  }

  @override
  Future<DataState<void>> deleteLearnedWord(WordEntity word) async {
    try {
      // Belirli bir kelimeyi silmek için word'ün id'sini kullanıyoruz
      await _hiveDatabaseService.deleteData<WordModel>(
        _learnedWordsBoxName,
        word.id,
      );
      return const DataSuccess(null);
    } on HiveError catch (e) {
      return DataFailed(
          exception: HiveExceptionCustom('Failed to delete learned word: $e'));
    } catch (e) {
      return DataFailed(
        exception: GenericException(
            'Unexpected error while deleting learned word: $e'),
      );
    }
  }

  @override
  Future<DataState<List<WordEntity>>> getLearnedWords() async {
    try {
      // Tüm öğrenilmiş kelimeleri alıyoruz
      final words = await _hiveDatabaseService.getAllData<WordModel>(
        _learnedWordsBoxName,
      );
      // WordModel listesini WordEntity listesine dönüştürüyoruz
      return DataSuccess(words.map((model) => model as WordEntity).toList());
    } on HiveError catch (e) {
      return DataFailed(
          exception: HiveExceptionCustom('Failed to get learned words: $e'));
    } catch (e) {
      return DataFailed(
        exception: GenericException(
            'Unexpected error while getting learned words: $e'),
      );
    }
  }

  @override
  Future<DataState<void>> learnWord(WordEntity word) async {
    try {
      // WordEntity'yi WordModel'a çevirip Hive'a kaydediyoruz
      final wordModel = WordModel.fromEntity(word);
      await _hiveDatabaseService.putData<WordModel>(
        _learnedWordsBoxName,
        wordModel.id,
        wordModel,
      );
      return const DataSuccess(null);
    } on HiveError catch (e) {
      return DataFailed(
          exception: HiveExceptionCustom('Failed to learn word: $e'));
    } catch (e) {
      return DataFailed(
        exception: GenericException('Unexpected error while learning word: $e'),
      );
    }
  }

  @override
  Future<DataState<List<WordEntity>>> getWords() async {
    try {
      // Kelimeleri ilgili box'lardan çekiyoruz
      final words = await _hiveDatabaseService.getAllData(
        _wordsBoxName,
        closeBoxAfterOperation: true
      );
      final learnedWords = await _hiveDatabaseService.getAllData(
        _learnedWordsBoxName,
        closeBoxAfterOperation: true,
      );

      if (words.isNotEmpty) {
        if (learnedWords.isNotEmpty) {
          // Öğrenilmiş kelimeleri ID bazlı çıkarıyoruz
          final unlearnedWords = words
              .where((word) =>
                  !learnedWords.any((learnedWord) => learnedWord.id == word.id))
              .toList();

          return DataSuccess(
              unlearnedWords.map((model) => model as WordEntity).toList());
        } else {
          return DataSuccess(
              words.map((model) => model as WordEntity).toList());
        }
      } else {
        return getWordsFromJsonAndSaveLocal();
      }
    } catch (e) {
      return DataFailed(
        exception: GenericException('Failed to load words: $e'),
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

  Future<DataState<List<WordEntity>>> getWordsFromJsonAndSaveLocal() async {
    try {
      // JSON dosyasını assets'ten okuyup listeye çeviriyoruz
      final String jsonString =
          await rootBundle.loadString(AssetEnum.ydsWords.toJson);
      final List<dynamic> jsonList = jsonDecode(jsonString);
      jsonList.shuffle();

      final List<WordModel> words = [];
      for (int i = 0; i < jsonList.length; i++) {
        words.add(WordModel.fromJson(jsonList[i]).copyWith(id: i.toString()));
      }

      // Tüm kelimeleri Hive'a kaydediyoruz
      for (var word in words) {
        await _hiveDatabaseService.putData(
          _wordsBoxName,
          word.id,
          word,
        );
      }
      return DataSuccess(words.map((model) => model as WordEntity).toList());
    } catch (e) {
      return DataFailed(
        exception: GenericException('Failed to load words from JSON: $e'),
      );
    }
  }

  @override
  Future<DataState<WordEntity>> getRandomWordForWidget() async {
    try {
      final wordsResult = await getWords(); // Mevcut öğrenilmemiş kelimeleri al
      if (wordsResult is DataSuccess && wordsResult.data!.isNotEmpty) {
        final words = wordsResult.data!;
        final randomIndex =
            DateTime.now().millisecondsSinceEpoch % words.length;
        return DataSuccess(words[randomIndex]);
      } else {
        return DataFailed(
          exception: GenericException('No unlearned words available'),
        );
      }
    } catch (e) {
      return DataFailed(
        exception: GenericException('Failed to get random word for widget: $e'),
      );
    }
  }

  Future<void> updateWidgetWithRandomWord() async {
    final result = await getRandomWordForWidget();
    if (result is DataSuccess) {
      final wordEntity = result.data!;
      // Widget’a kelime ve anlamını gönder
      await HomeWidget.saveWidgetData<String>('word_text', wordEntity.word);
      await HomeWidget.saveWidgetData<String>(
          'meaning_text', wordEntity.translation);
      // Android ve iOS için widget’ı güncelle
      await HomeWidget.updateWidget(
        name: 'WordWidgetProvider', // Android
        iOSName: 'WordWidget', // iOS
      );
    }
  }
}
