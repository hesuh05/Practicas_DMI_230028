package com.example.flip

import android.content.ComponentName
import android.content.pm.PackageManager
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

    private fun setSeasonIcon(season: String) {
        val packageManager = packageManager
        packageManager.setComponentEnabledSetting(
            ComponentName(this, "$packageName.MainActivity"),
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP,
        )
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
