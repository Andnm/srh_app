import 'package:flutter/material.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  static final AppLifecycleObserver _instance =
      AppLifecycleObserver._internal();
  factory AppLifecycleObserver() => _instance;
  AppLifecycleObserver._internal();

  final List<Function(AppLifecycleState)> _callbacks = [];

  void startObserving() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stopObserving() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void addCallback(Function(AppLifecycleState) callback) {
    _callbacks.add(callback);
  }

  void removeCallback(Function(AppLifecycleState) callback) {
    _callbacks.remove(callback);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // Xử lý khi ứng dụng trở lại trạng thái hoạt động
        _notifyCallbacks(state);
        break;
      case AppLifecycleState.inactive:
        // Xử lý khi ứng dụng không hoạt động
        _notifyCallbacks(state);
        break;
      case AppLifecycleState.paused:
        // Xử lý khi ứng dụng bị đẩy xuống chạy nền
        _notifyCallbacks(state);
        break;
      case AppLifecycleState.detached:
        // Xử lý khi ứng dụng bị tách rời khỏi flutter engine
        _notifyCallbacks(state);
        break;
      case AppLifecycleState.hidden:
        // Xử lý khi ứng dụng bị ẩn hoàn toàn
        _notifyCallbacks(state);
        break;
    }
  }

  void _notifyCallbacks(AppLifecycleState state) {
    for (final callback in _callbacks) {
      callback(state);
    }
  }
}
