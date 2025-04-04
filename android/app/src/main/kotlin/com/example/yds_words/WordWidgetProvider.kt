package com.example.yds_words

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.speech.tts.TextToSpeech
import android.util.Log
import android.widget.RemoteViews
import java.util.Locale

class WordWidgetProvider : AppWidgetProvider() {
    // TextToSpeech nesnesini sınıf seviyesinde tutuyoruz
    private var textToSpeech: TextToSpeech? = null
    private var isTtsInitialized = false

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        // TextToSpeech nesnesini yalnızca bir kez başlat
        if (textToSpeech == null) {
            textToSpeech = TextToSpeech(context) { status ->
                if (status == TextToSpeech.SUCCESS) {
                    textToSpeech?.language = Locale.US // İngilizce telaffuz için
                    isTtsInitialized = true
                    Log.d("TTS", "TextToSpeech başarıyla başlatıldı")
                } else {
                    Log.e("TTS", "TextToSpeech başlatılamadı: $status")
                }
            }
        }

        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == "SPEAK_WORD") {
            val word = intent.getStringExtra("word") ?: return
            if (isTtsInitialized && textToSpeech != null) {
                textToSpeech?.speak(word, TextToSpeech.QUEUE_FLUSH, null, null)
                Log.d("TTS", "Kelime okundu: $word")
            } else {
                Log.w("TTS", "TextToSpeech henüz hazır değil, kelime okunamadı: $word")
                // Eğer TTS hazır değilse, tekrar başlatmayı deneyebiliriz
                textToSpeech = TextToSpeech(context) { status ->
                    if (status == TextToSpeech.SUCCESS) {
                        textToSpeech?.language = Locale.US
                        isTtsInitialized = true
                        textToSpeech?.speak(word, TextToSpeech.QUEUE_FLUSH, null, null)
                        Log.d("TTS", "TextToSpeech yeniden başlatıldı ve kelime okundu: $word")
                    }
                }
            }
        }
    }

    override fun onDisabled(context: Context) {
        // Widget kaldırıldığında TTS’yi kapat
        textToSpeech?.shutdown()
        textToSpeech = null
        isTtsInitialized = false
        super.onDisabled(context)
    }

    companion object {
        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val views = RemoteViews(context.packageName, R.layout.word_widget_layout)
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val word = prefs.getString("flutter.word_text", "Kelime") ?: "1"
            val meaning = prefs.getString("flutter.meaning_text", "Anlam") ?: "2"
            val wordType = prefs.getString("flutter.meaning_text","Tip") ?:"3"
            Log.d("WidgetUpdate", "Okunan kelime: $word, Anlam: $meaning")

            // TextView’lara kelime ve anlamı set et
            views.setTextViewText(R.id.word_text, word)
            views.setTextViewText(R.id.meaning_text, meaning)
            views.setTextViewText(R.id.word_type,wordType)

            // Hoparlör ikonuna tıklama işlevi ekle
            val speakIntent = Intent(context, WordWidgetProvider::class.java).apply {
                action = "SPEAK_WORD"
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                putExtra("word", word) // Okunacak kelimeyi ekle
            }
            val pendingIntent = PendingIntent.getBroadcast(
                    context,
                    appWidgetId, // Her widget için benzersiz bir ID
                    speakIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.speaker_icon, pendingIntent)

            // Widget’ı güncelle
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}