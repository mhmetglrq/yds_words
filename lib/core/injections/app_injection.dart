import 'dart:io';
import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:workmanager/workmanager.dart';
import '../../features/ydsWords/data/dataSources/local/hive_database_service.dart';
import '../../features/ydsWords/data/dataSources/local/text_to_speech_service.dart';
import '../../features/ydsWords/data/dataSources/local/widget_updater.dart';
import '../../features/ydsWords/data/models/word_model.dart';
import 'word_learning_injection.dart';

final sl = GetIt.instance;
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final widgetUpdater = sl<WidgetUpdater>();
    await widgetUpdater.updateWidget();
    return Future.value(true);
  });
}

class AppInjection {
  static Future<void> init() async {
    sl.registerLazySingleton<HiveDatabaseService>(
      () => HiveDatabaseService.instance,
    );

    HiveDatabaseService.registerAdapter(WordModelAdapter());
    await HiveDatabaseService.init();

    sl.registerLazySingleton<TextToSpeechService>(
      () => TextToSpeechService(),
    );

    WordLearningInjection.init();

    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    // Widget'ı ilk açılışta güncelle
    if (Platform.isIOS) {
      final widgetUpdater = sl<WidgetUpdater>();
      await widgetUpdater.updateWidget();

      // iOS için de periyodik görev ekle
      Timer.periodic(const Duration(minutes: 15), (_) async {
        await widgetUpdater.updateWidget();
      });
    }

    if (Platform.isAndroid) {
      Workmanager().registerPeriodicTask(
        "wordWidgetUpdate",
        "updateWordWidget",
        frequency: const Duration(minutes: 15),
        initialDelay: const Duration(seconds: 10),
      );
    }
  }

  static void dispose() {
    sl<HiveDatabaseService>().closeAllBoxes();
    sl<TextToSpeechService>().stop();
  }
}
