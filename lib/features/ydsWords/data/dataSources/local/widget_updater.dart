import 'dart:developer';

import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yds_words/core/resources/data_state.dart';
import 'package:yds_words/features/ydsWords/domain/entities/word_entity.dart';
import 'package:yds_words/features/ydsWords/domain/repositories/word_learning_repository.dart';

class WidgetUpdater {
  final WordLearningRepository _wordLearningRepository;

  WidgetUpdater(this._wordLearningRepository);

  Future<void> updateWidget() async {
    final DataState<WordEntity> result =
        await _wordLearningRepository.getRandomWordForWidget();
    if (result is DataSuccess) {
      final wordEntity = result.data!;
      log("Gönderilen kelime: ${wordEntity.word}, Anlam: ${wordEntity.translation}");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // Veri yazımını kontrol et
      final wordSaved =
          // await HomeWidget.saveWidgetData<String>('word_text', wordEntity.word);
          await prefs.setString("word_text", wordEntity.word);
      final meaningSaved =
          //  await HomeWidget.saveWidgetData<String>(
          //     'meaning_text', wordEntity.translation);
          await prefs.setString("meaning_text", wordEntity.translation);
      log("Kelime kaydedildi mi? $wordSaved, Anlam kaydedildi mi? $meaningSaved");

      final updateSuccess = await HomeWidget.updateWidget(
        name: 'WordWidgetProvider',
        iOSName: 'WordWidget',
      );
      log("Widget güncelleme başarılı mı? $updateSuccess");
    } else {
      log("Hata: ${result.message}");
    }
  }
}
