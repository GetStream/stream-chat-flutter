package com.example.example

import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin
import io.flutter.plugins.pathprovider.PathProviderPlugin

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        PathProviderPlugin.registerWith(registry?.registrarFor(
                "io.flutter.plugins.pathprovider.PathProviderPlugin"))
        SharedPreferencesPlugin.registerWith(registry?.registrarFor(
                "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"))
        FlutterLocalNotificationsPlugin.registerWith(registry?.registrarFor(
                "com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"))
        FirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
    }
}