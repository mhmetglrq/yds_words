package com.example.yds_words

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.work.Worker
import androidx.work.WorkerParameters
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch
import java.util.concurrent.atomic.AtomicReference

class WidgetUpdateWorker(context: Context, params: WorkerParameters) : Worker(context, params) {

    /**
     * FlutterEngine ve DartExecutor’u mutlaka main (UI) thread’de oluşturmak gerekir.
     * Bu metot, arka plandaki Worker thread’den çağrılsa bile, esas motor oluşturma işlemini UI thread’de yapar.
     */
    private fun createFlutterEngineOnMainThread(context: Context): FlutterEngine {
        val engineRef = AtomicReference<FlutterEngine>()
        val latch = CountDownLatch(1)

        // Main thread’de FlutterEngine oluştur
        Handler(Looper.getMainLooper()).post {
            val engine = FlutterEngine(context)
            val dartEntrypoint = DartExecutor.DartEntrypoint.createDefault()
            engine.dartExecutor.executeDartEntrypoint(dartEntrypoint)
            engineRef.set(engine)
            latch.countDown()
        }

        // FlutterEngine kurulumu bitene kadar bekle
        latch.await()
        return engineRef.get()
    }

    override fun doWork(): Result {
        // 1) FlutterEngine’i main thread’de oluştur
        val flutterEngine = createFlutterEngineOnMainThread(applicationContext)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app.channel")

        // 2) MethodChannel invokeMethod’unu da yine main thread’de yaptır
        val resultRef = AtomicReference<Result>(Result.failure())
        val latch = CountDownLatch(1)

        Handler(Looper.getMainLooper()).post {
            channel.invokeMethod("updateWidget", null, object : MethodChannel.Result {
                override fun success(resultData: Any?) {
                    resultRef.set(Result.success())
                    latch.countDown()
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    resultRef.set(Result.failure())
                    latch.countDown()
                }

                override fun notImplemented() {
                    resultRef.set(Result.failure())
                    latch.countDown()
                }
            })
        }

        // 3) Flutter MethodChannel çağrısı bitene kadar bekle
        latch.await()

        // 4) Son olarak, FlutterEngine’i kapatmak (destroy) işlemini yine main thread’de yapmak mantıklı
        Handler(Looper.getMainLooper()).post {
            flutterEngine.destroy()
        }

        // 5) Worker’a dönecek sonucu ver
        return resultRef.get()
    }
}