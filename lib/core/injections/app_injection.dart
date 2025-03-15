import 'package:get_it/get_it.dart';
import '../../features/ydsWords/data/dataSources/local/hive_database_service.dart';
import '../../features/ydsWords/data/dataSources/local/text_to_speech_service.dart';
import '../../features/ydsWords/data/models/word_model.dart';
import 'word_learning_injection.dart';

final sl = GetIt.instance;

class AppInjection {
  static Future<void> init() async {
    // HiveDatabaseService'i kaydet
    sl.registerLazySingleton<HiveDatabaseService>(
      () => HiveDatabaseService.instance,
    );

    // Hive başlatma ve adapter kaydı
    HiveDatabaseService.registerAdapter(WordModelAdapter());
    await HiveDatabaseService.init(); // await ekledik

    // TextToSpeechService
    sl.registerLazySingleton<TextToSpeechService>(
      () => TextToSpeechService(),
    );

    // WordLearning modülünü başlat
    WordLearningInjection.init();
  }

  static void dispose() {
    // Hive kaynaklarını temizle
    sl<HiveDatabaseService>().closeAllBoxes();
    // TTS için özel bir dispose gerekmez, ama stop etmek isterseniz:
    sl<TextToSpeechService>().stop();
  }
}
