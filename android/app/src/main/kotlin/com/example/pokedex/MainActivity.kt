package com.example.pokedex

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.firebase.analytics.FirebaseAnalytics

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.pokedex.features/analytics"
    private lateinit var firebaseAnalytics: FirebaseAnalytics

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        firebaseAnalytics = FirebaseAnalytics.getInstance(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            
            if (call.arguments != null) {
                 println("[AnalyticsPlugin][Android] Method: ${call.method} | Args: ${call.arguments}")
            } else {
                 println("[AnalyticsPlugin][Android] Method: ${call.method} | No Args")
            }

            when (call.method) {
                "logEvent" -> {
                    val name = call.argument<String>("name")
                    val parameters = call.argument<Map<String, Any>>("parameters")

                    if (name != null) {
                        println("[AnalyticsPlugin][Android] logEvent -> Name: $name, Params: $parameters")
                        
                        val bundle = Bundle()
                        parameters?.forEach { (key, value) ->
                            when (value) {
                                is String -> bundle.putString(key, value)
                                is Int -> bundle.putLong(key, value.toLong())
                                is Long -> bundle.putLong(key, value)
                                is Double -> bundle.putDouble(key, value)
                                is Boolean -> bundle.putBoolean(key, value)
                            }
                        }
                        
                        firebaseAnalytics.logEvent(name, bundle)
                        result.success(null)
                    } else {
                        println("[AnalyticsPlugin][Android] Error: Invalid arguments for logEvent")
                        result.error("INVALID_ARGUMENTS", "Event name is required", null)
                    }
                }
                "setUserId" -> {
                    val userId = call.argument<String>("userId")
                    if (userId != null) {
                        println("[AnalyticsPlugin][Android] setUserId -> ID: $userId")
                        firebaseAnalytics.setUserId(userId)
                        result.success(null)
                    } else {
                         println("[AnalyticsPlugin][Android] Error: Invalid arguments for setUserId")
                        result.error("INVALID_ARGUMENTS", "User ID is required", null)
                    }
                }
                "setUserProperty" -> {
                    val name = call.argument<String>("name")
                    val value = call.argument<String>("value")
                    if (name != null && value != null) {
                        println("[AnalyticsPlugin][Android] setUserProperty -> Name: $name, Value: $value")
                        firebaseAnalytics.setUserProperty(name, value)
                        result.success(null)
                    } else {
                         println("[AnalyticsPlugin][Android] Error: Invalid arguments for setUserProperty")
                        result.error("INVALID_ARGUMENTS", "Name and value are required", null)
                    }
                }
                "setCurrentScreen" -> {
                    val screenName = call.argument<String>("screenName")
                    val screenClass = call.argument<String>("screenClassOverride") ?: "MainActivity"
                    
                    if (screenName != null) {
                        println("[AnalyticsPlugin][Android] setCurrentScreen -> Name: $screenName, Class: $screenClass")
                        
                        val params = Bundle()
                        params.putString(FirebaseAnalytics.Param.SCREEN_NAME, screenName)
                        params.putString(FirebaseAnalytics.Param.SCREEN_CLASS, screenClass)
                        firebaseAnalytics.logEvent(FirebaseAnalytics.Event.SCREEN_VIEW, params)
                        
                        result.success(null)
                    } else {
                         println("[AnalyticsPlugin][Android] Error: Invalid arguments for setCurrentScreen")
                        result.error("INVALID_ARGUMENTS", "Screen name is required", null)
                    }
                }
                else -> {
                     println("[AnalyticsPlugin][Android] Error: Method not implemented: ${call.method}")
                    result.notImplemented()
                }
            }
        }
    }
}
