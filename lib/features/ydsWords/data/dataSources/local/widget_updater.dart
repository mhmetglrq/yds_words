import 'dart:developer';
import 'dart:io';

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
      await HomeWidget.setAppGroupId('group.com.example.yds-words');
      final wordEntity = result.data!;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString("word_text", wordEntity.word);
      await prefs.setString("meaning_text", wordEntity.translation);
      await prefs.setString("word_type", wordEntity.type);

      if (Platform.isIOS) {
        // iOS için widget'ı zorla güncelle
        await HomeWidget.saveWidgetData<String>('word_text', wordEntity.word);
        await HomeWidget.saveWidgetData<String>(
            'meaning_text', wordEntity.translation);
        await HomeWidget.saveWidgetData<String>('word_type', wordEntity.type);

        // Widget'ı birkaç kez güncellemeyi dene
        for (var i = 0; i < 3; i++) {
          final updateSuccess = await HomeWidget.updateWidget(
            name: 'WordWidgetProvider',
            iOSName: 'WordWidget',
            qualifiedAndroidName: '',
          );
          log("iOS Widget güncelleme denemesi ${i + 1}: $updateSuccess");
          await Future.delayed(const Duration(seconds: 1));
        }
      } else {
        final updateSuccess = await HomeWidget.updateWidget(
          name: 'WordWidgetProvider',
          iOSName: 'WordWidget',
        );
        log("Widget güncelleme başarılı mı? $updateSuccess");
      }
    } else {
      log("Hata: ${result.message}");
    }
  }
}
