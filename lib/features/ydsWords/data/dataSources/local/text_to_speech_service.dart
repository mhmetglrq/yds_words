import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();

  TextToSpeechService() {
    _initTts();
  }

  Future<void> _initTts() async {
    // Dil ayarını yap (örneğin İngilizce)
    await _flutterTts.setLanguage("en-US");

    // Ses seviyesini, hızını ve tonunu ayarla (opsiyonel)
    await _flutterTts.setVolume(1.0); // 0.0 - 1.0
    await _flutterTts.setSpeechRate(0.5); // 0.1 - 1.0 (yavaşlık/hız)
    await _flutterTts.setPitch(1.0); // 0.5 - 2.0 (ton)
  }

  Future<void> speak(String text) async {
    // Kelimeyi seslendir
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    // Seslendirmeyi durdur (opsiyonel)
    await _flutterTts.stop();
  }

  Future<void> setLanguage(String language) async {
    // Dil değiştir (örneğin "tr-TR" için Türkçe)
    await _flutterTts.setLanguage(language);
  }
}
