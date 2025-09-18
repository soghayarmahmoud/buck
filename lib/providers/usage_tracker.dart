import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:buck/components/usage_service.dart';

class UsageTracker extends ChangeNotifier with WidgetsBindingObserver {
  Timer? _timer;
  int _dailySeconds = 0;
  int _totalSeconds = 0;
  DateTime? _sessionStart;

  int get dailySeconds => _dailySeconds;
  int get totalSeconds => _totalSeconds;

  UsageTracker() {
    WidgetsBinding.instance.addObserver(this);
    _requestPermissions();
    _loadData();
    _startSession();
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();
    await Permission.storage.request(); // لحفظ الحديث كصورة
  }

  Future<void> _loadData() async {
    _dailySeconds = await UsageService.getDailySeconds();
    _totalSeconds = await UsageService.getTotalSeconds();
    notifyListeners();
  }

  void _startSession() {
    _sessionStart = DateTime.now();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _dailySeconds++;
      _totalSeconds++;
      notifyListeners();
    });
  }

  Future<void> _endSession() async {
    if (_sessionStart != null) {
      final seconds = DateTime.now().difference(_sessionStart!).inSeconds;
      _dailySeconds += seconds;
      _totalSeconds += seconds;
    }

    _timer?.cancel();
    _timer = null;
    _sessionStart = null;

    await UsageService.saveDailySeconds(_dailySeconds);
    await UsageService.saveTotalSeconds(_totalSeconds);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _endSession();
    } else if (state == AppLifecycleState.resumed) {
      _startSession();
    }
  }

  @override
  void dispose() {
    _endSession();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
