import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  static const String _boxName = 'learnedWords'; // Sabit bir box adı

  WordLearningRepositoryImpl(this._hiveDatabaseService, this._ttsService);

  @override
  Future<DataState<void>> deleteAllLearnedWords() async {
    try {
      // Tüm öğrenilmiş kelimeleri silmek için box'ı temizliyoruz
      await _hiveDatabaseService.clearBox<WordModel>(
        _boxName,
        closeBoxAfterOperation: true,
      );
      return const DataSuccess(null); // Başarılıysa null dönüyoruz (void için)
    } on HiveError catch (e) {
      // Hive ile ilgili bir hata varsa HiveExceptionCustom kullanıyoruz
      return DataFailed(
          exception:
              HiveExceptionCustom('Failed to delete all learned words: $e'));
    } catch (e) {
      // Diğer hatalar için GenericException kullanıyoruz
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
        _boxName,
        word.id,
        closeBoxAfterOperation: true,
      );
      return const DataSuccess(null); // Başarılıysa null dönüyoruz
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
        _boxName,
        closeBoxAfterOperation: true,
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
        _boxName,
        wordModel.id, // ID'yi key olarak kullanıyoruz
        wordModel,
        closeBoxAfterOperation: true,
      );
      return const DataSuccess(null); // Başarılıysa null dönüyoruz
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
      // JSON dosyasını assets'ten oku
      final String jsonString =
          await rootBundle.loadString(AssetEnum.ydsWords.toJson);

      // JSON string'ini Dart nesnesine çevir
      final List<dynamic> jsonList = jsonDecode(jsonString);

      final List<WordModel> words = [];
      // JSON verisini WordModel listesine dönüştür
      for (int i = 0; i < jsonList.length; i++) {
        words.add(WordModel.fromJson(jsonList[i]).copyWith(id: i.toString()));
      }
      words.shuffle(); // Kelimeleri karıştır

      // WordModel listesini WordEntity listesine çevir ve dön
      return DataSuccess(words.map((model) => model as WordEntity).toList());
    } catch (e) {
      return DataFailed(
        exception: GenericException('Failed to load words from JSON: $e'),
      );
    }
  }

  @override
  Future<DataState<void>> speakWord(String word) async {
    try {
      // Kelimeyi İngilizce olarak seslendir
      await _ttsService.setLanguage('en-US'); // Dil ayarını yap
      await _ttsService.speak(word); // Kelimeyi seslendir
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(
        exception: GenericException('Failed to speak word: $e'),
      );
    }
  }
}
