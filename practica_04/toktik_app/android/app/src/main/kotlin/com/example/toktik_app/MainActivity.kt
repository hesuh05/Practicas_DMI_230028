package com.example.toktik

import android.media.MediaExtractor
import android.media.MediaFormat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val executor = Executors.newSingleThreadExecutor()

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
