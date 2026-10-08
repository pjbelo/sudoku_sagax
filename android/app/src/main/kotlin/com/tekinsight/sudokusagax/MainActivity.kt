package com.tekinsight.sudokusagax

import android.media.AudioManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val ringerChannel = "com.tekinsight.sudokusagax/ringer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ringerChannel,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getRingerMode" -> {
                    val am = getSystemService(AUDIO_SERVICE) as AudioManager
                    result.success(am.ringerMode)
                }
                else -> result.notImplemented()
            }
        }
    }
}
