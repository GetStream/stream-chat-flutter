package com.example.example

import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
import com.example.path_provider.PathProviderPlugin
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        FlutterLocalNotificationsPlugin.registerWith(registry?.registrarFor(
                "com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"))
        SharedPreferencesPlugin.registerWith(registry?.registrarFor(
                "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"))
        FirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
    }
}