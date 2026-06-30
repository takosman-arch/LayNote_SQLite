package com.example.flutter_application_1

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    // main.dart içindeki _appCheckChannel ile aynı kanal adı olmalı.
    private val APP_CHECK_CHANNEL = "com.dnote.app/appcheck"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APP_CHECK_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isAppInstalled" -> {
                        val packageName = call.argument<String>("packageName")
                        if (packageName == null) {
                            result.success(false)
                        } else {
                            val isInstalled = try {
                                packageManager.getPackageInfo(packageName, 0)
                                true
                            } catch (e: Exception) {
                                false
                            }
                            result.success(isInstalled)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
