import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarksProvider extends ChangeNotifier {
  Map<int, int> _bookmarks = {}; // chapterId -> hadithId

  BookmarksProvider() {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    _bookmarks = {};
    for (var key in keys) {
      if (key.startsWith("bookmark_")) {
        final chapterId = int.parse(key.replaceFirst("bookmark_", ""));
        final hadithId = prefs.getInt(key);
        if (hadithId != null) {
          _bookmarks[chapterId] = hadithId;
        }
      }
    }
    notifyListeners();
  }

  int? getBookmark(int chapterId) => _bookmarks[chapterId];

  Future<void> setBookmark(int chapterId, int hadithId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("bookmark_$chapterId", hadithId);
    _bookmarks[chapterId] = hadithId;
    notifyListeners();
  }
}
