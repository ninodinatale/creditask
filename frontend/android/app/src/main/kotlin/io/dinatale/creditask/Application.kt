package io.dinatale.creditask

class Application : FlutterApplication(), PluginRegistrantCallback {
    @Override
    fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }

    @Override
    fun registerWith(registry: PluginRegistry?) {
        GeneratedPluginRegistrant.registerWith(registry)
    }
}
