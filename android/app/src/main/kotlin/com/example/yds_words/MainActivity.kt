package com.example.yds_words

import io.flutter.embedding.android.FlutterActivity
import androidx.work.*
import java.util.concurrent.TimeUnit

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        val workRequest = PeriodicWorkRequestBuilder<WidgetUpdateWorker>(
            30, TimeUnit.MINUTES // 30 dakika
        ).build()

        WorkManager.getInstance(this).enqueueUniquePeriodicWork(
            "widgetUpdateWork",
            ExistingPeriodicWorkPolicy.KEEP,
            workRequest
        )
    }


}