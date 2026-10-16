package com.example.flip

import android.content.ComponentName
import android.content.pm.PackageManager
import android.os.Bundle
import java.util.Calendar
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "flip/app_icon"
    private val iconAliases = mapOf(
        "normal" to "NormalIcon",
        "halloween" to "HalloweenIcon",
        "christmas" to "ChristmasIcon",
        "valentines" to "ValentinesIcon",
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        setSeasonIcon(seasonForCurrentDate())
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method != "setSeason") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val season = call.argument<String>("season")
                if (season == null || !iconAliases.containsKey(season)) {
                    result.error("INVALID_SEASON", "Unknown app season: $season", null)
                    return@setMethodCallHandler
                }
                setSeasonIcon(season)
                result.success(null)
            }
    }

    private fun seasonForCurrentDate(): String {
        val calendar = Calendar.getInstance()
        val month = calendar.get(Calendar.MONTH) + 1
        val day = calendar.get(Calendar.DAY_OF_MONTH)
        return when {
            (month == 10 && day >= 30) || (month == 11 && day <= 3) -> "halloween"
            (month == 12 && day >= 5) || (month == 1 && day <= 5) -> "christmas"
            month == 2 && day == 14 -> "valentines"
            else -> "normal"
        }
    }

    private fun setSeasonIcon(season: String) {
        val packageManager = packageManager
        iconAliases.forEach { (name, alias) ->
            val state = if (name == season) {
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            } else {
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            }
            packageManager.setComponentEnabledSetting(
                ComponentName(this, "${packageName}.$alias"),
                state,
                PackageManager.DONT_KILL_APP,
            )
        }
    }
}
