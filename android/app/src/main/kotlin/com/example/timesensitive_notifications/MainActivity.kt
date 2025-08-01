package com.example.timesensitive_notifications


import android.app.NotificationManager
import android.content.Context
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import androidx.lifecycle.ProcessLifecycleOwner
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), LifecycleObserver {
    private val CHANNEL = "notification_service"
    private val callNotificationId = 1001

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        ProcessLifecycleOwner.get().lifecycle.addObserver(this)

        // Setup method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "removeNotification" -> {
                    removeNotification()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    fun onAppBackgrounded() {
        // App went to background
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_DESTROY)
    fun onAppDestroyed() {
        // App is being destroyed
        removeNotification()
    }

    private fun removeNotification() {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(callNotificationId)
    }
}