import 'dart:developer';

import 'package:flutter/services.dart';

class AnalyticsService {
  static const MethodChannel _channel = MethodChannel(
    'com.pokedex.features/analytics',
  );

  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _channel.invokeMethod('logEvent', {
        'name': name,
        'parameters': parameters,
      });
    } on PlatformException catch (e) {
      log('Failed to log event: ${e.message}');
    }
  }

  Future<void> setUserId(String userId) async {
    try {
      await _channel.invokeMethod('setUserId', {'userId': userId});
    } on PlatformException catch (e) {
      log('Failed to set user ID: ${e.message}');
    }
  }

  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await _channel.invokeMethod('setUserProperty', {
        'name': name,
        'value': value,
      });
    } on PlatformException catch (e) {
      log('Failed to set user property: ${e.message}');
    }
  }

  Future<void> setCurrentScreen({
    required String screenName,
    String? screenClassOverride,
  }) async {
    try {
      await _channel.invokeMethod('setCurrentScreen', {
        'screenName': screenName,
        'screenClassOverride': screenClassOverride,
      });
    } on PlatformException catch (e) {
      log('Failed to set current screen: ${e.message}');
    }
  }
}
