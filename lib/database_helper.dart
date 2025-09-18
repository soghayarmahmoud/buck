// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// // Models
// import 'models/chaper.dart';
// import 'models/hadith.dart';

// // Import data file (لازم تكون مجهّز lists فيه)
// import 'hadith_data.dart';

// class DatabaseHelper {
//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   static Database? _database;

//   static const String _databaseName = 'hadith_db.db';
//   static const int _databaseVersion = 2;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     final databasePath = await getDatabasesPath();
//     final path = join(databasePath, _databaseName);

//     return await openDatabase(
//       path,
//       version: _databaseVersion,
//       onCreate: _onCreate,
//       onUpgrade: _onUpgrade,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE chapter(
//         id INTEGER PRIMARY KEY,
//         title TEXT NOT NULL,
//         hadith_count INTEGER NOT NULL
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE hadith(
//         id INTEGER PRIMARY KEY,
//         chapter_id INTEGER NOT NULL,
//         hadith_text TEXT NOT NULL,
//         is_favorite INTEGER NOT NULL DEFAULT 0,
//         FOREIGN KEY (chapter_id) REFERENCES chapter(id) ON DELETE CASCADE
//       )
//     ''');

//     // ✅ أول مرة تتعمل DB: نضيف البيانات من hadith_data.dart
//     Batch batch = db.batch();

//     for (var chapter in hadithChapters) {
//       batch.insert('chapter', chapter.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//     }
//     for (var hadith in hadithList) {
//       batch.insert('hadith', hadith.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//     }

//     await batch.commit();
//   }

//   Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
//     if (oldVersion < 2) {
//       await db.execute(
//         'ALTER TABLE hadith ADD COLUMN is_favorite INTEGER NOT NULL DEFAULT 0'
//       );
//     }
//   }

//   // ================== CRUD & Utils ==================

//   Future<void> insertChapters(List<Chapter> chapters) async {
//     final db = await database;
//     final batch = db.batch();
//     for (var chapter in chapters) {
//       batch.insert('chapter', chapter.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//     }
//     await batch.commit();
//   }

//   Future<void> insertHadiths(List<Hadith> hadiths) async {
//     final db = await database;
//     final batch = db.batch();
//     for (var hadith in hadiths) {
//       batch.insert('hadith', hadith.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//     }
//     await batch.commit();
//   }

//   Future<List<Chapter>> getChapters() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('chapter');
//     return List.generate(maps.length, (i) {
//       return Chapter(
//         id: maps[i]['id'],
//         title: maps[i]['title'],
//         hadithCount: maps[i]['hadith_count'],
//       );
//     });
//   }

//   Future<Chapter?> getChapterById(int id) async {
//     final db = await database;
//     final maps = await db.query(
//       'chapter',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (maps.isNotEmpty) {
//       return Chapter(
//         id: maps.first['id'] as int,
//         title: maps.first['title'] as String,
//         hadithCount: maps.first['hadith_count'] as int,
//       );
//     }
//     return null;
//   }

//   Future<List<Hadith>> getHadiths(int chapterId) async {
//     final db = await database;
//     final maps = await db.query(
//       'hadith',
//       where: 'chapter_id = ?',
//       whereArgs: [chapterId],
//     );
//     return maps.map((e) => Hadith.fromMap(e)).toList();
//   }

//   Future<Hadith?> getRandomHadith() async {
//     final db = await database;
//     final maps = await db.rawQuery(
//       'SELECT * FROM hadith ORDER BY RANDOM() LIMIT 1'
//     );
//     if (maps.isNotEmpty) {
//       return Hadith.fromMap(maps.first);
//     }
//     return null;
//   }

//   Future<List<Hadith>> searchHadiths(String keyword) async {
//     final db = await database;
//     final maps = await db.query(
//       'hadith',
//       where: 'hadith_text LIKE ?',
//       whereArgs: ['%$keyword%'],
//     );
//     return maps.map((e) => Hadith.fromMap(e)).toList();
//   }

//   Future<List<Hadith>> getFavoriteHadiths() async {
//     final db = await database;
//     final maps = await db.query(
//       'hadith',
//       where: 'is_favorite = ?',
//       whereArgs: [1],
//     );
//     return maps.map((e) => Hadith.fromMap(e)).toList();
//   }

//   Future<void> toggleFavorite(int hadithId, bool isFavorite) async {
//     final db = await database;
//     await db.update(
//       'hadith',
//       {'is_favorite': isFavorite ? 1 : 0},
//       where: 'id = ?',
//       whereArgs: [hadithId],
//     );
//   }
// }


import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Models
import 'models/chaper.dart';
import 'models/hadith.dart';

// Import data file (لازم تكون مجهّز lists فيه)
import 'hadith_data.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  static const String _databaseName = 'hadith_db.db';
  static const int _databaseVersion = 2;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chapter(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        hadith_count INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE hadith(
        id INTEGER PRIMARY KEY,
        chapter_id INTEGER NOT NULL,
        hadith_text TEXT NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (chapter_id) REFERENCES chapter(id) ON DELETE CASCADE
      )
    ''');

    // ✅ أول مرة تتعمل DB: نضيف البيانات من hadith_data.dart
    Batch batch = db.batch();

    for (var chapter in hadithChapters) {
      batch.insert('chapter', chapter.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    for (var hadith in hadithList) {
      batch.insert('hadith', hadith.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE hadith ADD COLUMN is_favorite INTEGER NOT NULL DEFAULT 0'
      );
    }
  }

  // ================== CRUD & Utils ==================

  Future<void> insertChapters(List<Chapter> chapters) async {
    final db = await database;
    final batch = db.batch();
    for (var chapter in chapters) {
      batch.insert('chapter', chapter.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<void> insertHadiths(List<Hadith> hadiths) async {
    final db = await database;
    final batch = db.batch();
    for (var hadith in hadiths) {
      batch.insert('hadith', hadith.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<List<Chapter>> getChapters() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('chapter');
    return List.generate(maps.length, (i) {
      return Chapter(
        id: maps[i]['id'],
        title: maps[i]['title'],
        hadithCount: maps[i]['hadith_count'],
      );
    });
  }

  Future<Chapter?> getChapterById(int id) async {
    final db = await database;
    final maps = await db.query(
      'chapter',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Chapter(
        id: maps.first['id'] as int,
        title: maps.first['title'] as String,
        hadithCount: maps.first['hadith_count'] as int,
      );
    }
    return null;
  }

  Future<List<Hadith>> getHadiths(int chapterId) async {
    final db = await database;
    final maps = await db.query(
      'hadith',
      where: 'chapter_id = ?',
      whereArgs: [chapterId],
    );
    return maps.map((e) => Hadith.fromMap(e)).toList();
  }

  Future<Hadith?> getRandomHadith() async {
    final db = await database;
    final maps = await db.rawQuery(
      'SELECT * FROM hadith ORDER BY RANDOM() LIMIT 1'
    );
    if (maps.isNotEmpty) {
      return Hadith.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Hadith>> searchHadiths(String keyword) async {
    final db = await database;
    final maps = await db.query(
      'hadith',
      where: 'hadith_text LIKE ?',
      whereArgs: ['%$keyword%'],
    );
    return maps.map((e) => Hadith.fromMap(e)).toList();
  }

  Future<List<Hadith>> getFavoriteHadiths() async {
    final db = await database;
    final maps = await db.query(
      'hadith',
      where: 'is_favorite = ?',
      whereArgs: [1],
    );
    return maps.map((e) => Hadith.fromMap(e)).toList();
  }

  Future<void> toggleFavorite(int hadithId, bool isFavorite) async {
    final db = await database;
    await db.update(
      'hadith',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [hadithId],
    );
  }

  // 🆕 دالة لإعادة تهيئة القاعدة
  Future<void> resetDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    // 🗑️ حذف القاعدة القديمة
    await deleteDatabase(path);

    // ⬇️ reset للـ instance
    _database = null;

    // 🆕 إعادة تهيئة القاعدة
    await database;
  }
}
