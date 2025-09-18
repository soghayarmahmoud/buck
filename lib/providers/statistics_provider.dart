import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StatisticsProvider extends ChangeNotifier {
  final Map<int, int> _hadithsPerChapter;

  int _totalSessionTimeInSeconds = 0;
  int _totalReadHadiths = 0;
  Map<int, int> _chapterProgress = {};

  int get totalSessionTimeInSeconds => _totalSessionTimeInSeconds;
  int get totalReadHadiths => _totalReadHadiths;
  Map<int, int> get chapterProgress => _chapterProgress;
  Map<int, int> get hadithsPerChapter => _hadithsPerChapter;

  bool _isInitialized = false;

  StatisticsProvider(this._hadithsPerChapter) {
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    _totalSessionTimeInSeconds = prefs.getInt('totalSessionTime') ?? 0;
    _totalReadHadiths = prefs.getInt('totalReadHadiths') ?? 0;

    final progressJson = prefs.getString('chapterProgress');
    if (progressJson != null) {
      _chapterProgress = Map<int, int>.from(jsonDecode(progressJson).map((k, v) => MapEntry(int.parse(k), v)));
    } else {
      _chapterProgress = Map.from(_hadithsPerChapter.map((key, value) => MapEntry(key, 0)));
    }

    _chapterProgress.removeWhere((key, value) => !_hadithsPerChapter.containsKey(key));
    _hadithsPerChapter.forEach((key, value) {
      _chapterProgress.putIfAbsent(key, () => 0);
    });

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _saveStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalSessionTime', _totalSessionTimeInSeconds);
    await prefs.setInt('totalReadHadiths', _totalReadHadiths);
    await prefs.setString('chapterProgress', jsonEncode(_chapterProgress));
  }
  
  // دالة جديدة لإضافة وقت الجلسة
  void addSessionTime(int seconds) {
    _totalSessionTimeInSeconds += seconds;
    _saveStatistics();
    notifyListeners();
  }

  void registerHadithRead(int chapterId, int hadithId) {
    if (_isInitialized) {
      _totalReadHadiths++;
      _chapterProgress[chapterId] = (_chapterProgress[chapterId] ?? 0) + 1;
      _saveStatistics();
      notifyListeners();
    }
  }

  void resetStatistics() {
    _totalSessionTimeInSeconds = 0;
    _totalReadHadiths = 0;
    _chapterProgress = Map.from(_hadithsPerChapter.map((key, value) => MapEntry(key, 0)));
    _saveStatistics();
    notifyListeners();
  }
}
