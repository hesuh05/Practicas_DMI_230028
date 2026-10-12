package com.example.toktik

import android.media.MediaExtractor
import android.media.MediaFormat
import android.content.ComponentName
import android.content.pm.PackageManager
import java.util.Calendar
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val executor = Executors.newSingleThreadExecutor()

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        updateSeasonalLauncherIcon()
        super.onCreate(savedInstanceState)
    }

    private fun updateSeasonalLauncherIcon() {
        val calendar = Calendar.getInstance()
        val month = calendar.get(Calendar.MONTH) + 1
        val day = calendar.get(Calendar.DAY_OF_MONTH)
        val alias = when {
            month == 10 && day >= 30 || month == 11 && day <= 3 ->
                "MainActivityHalloween"
            month == 12 && day >= 5 || month == 1 && day <= 5 ->
                "MainActivityChristmas"
            month == 2 && day == 14 ->
                "MainActivityValentines"
            else -> "MainActivityNormal"
        }
        val aliases = listOf(
            "MainActivityNormal",
            "MainActivityHalloween",
            "MainActivityChristmas",
            "MainActivityValentines",
        )
        aliases.forEach { name ->
            packageManager.setComponentEnabledSetting(
                ComponentName(this, "$packageName.$name"),
                if (name == alias) {
                    PackageManager.COMPONENT_ENABLED_STATE_ENABLED
                } else {
                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED
                },
                PackageManager.DONT_KILL_APP,
            )
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "toktik/audio")
            .setMethodCallHandler { call, result ->
                if (call.method != "hasAudioTrack") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val url = call.argument<String>("url")
                if (url.isNullOrBlank()) {
                    result.error("INVALID_URL", "Video URL is required.", null)
                    return@setMethodCallHandler
                }
                executor.execute {
                    try {
                        val hasAudio = hasAudioTrack(url)
                        runOnUiThread { result.success(hasAudio) }
                    } catch (error: Exception) {
                        runOnUiThread {
                            result.error(
                                "AUDIO_METADATA_ERROR",
                                "Could not inspect the video's audio track.",
                                error.message,
                            )
                        }
                    }
                }
            }
    }

    private fun hasAudioTrack(url: String): Boolean {
        val headers = mapOf(
            "User-Agent" to "TokTik/1.0",
            "Accept" to "*/*",
        )
        var extractor: MediaExtractor? = null
        try {
            extractor = MediaExtractor()
            extractor.setDataSource(url, headers)
            for (index in 0 until extractor.trackCount) {
                val format = extractor.getTrackFormat(index)
                val mime = format.getString(MediaFormat.KEY_MIME) ?: continue
                if (mime.startsWith("audio/")) return true
            }
            return false
        } finally {
            extractor?.release()
        }
    }

    override fun onDestroy() {
        executor.shutdownNow()
        super.onDestroy()
    }
}
