// lib/models/hadith.dart
class Hadith {
  final int id;
  final int chapterId;
  final String text;
  final bool isFavorite;

  Hadith({
    required this.id,
    required this.chapterId,
    required this.text,
    this.isFavorite = false,
  });

  factory Hadith.fromMap(Map<String, dynamic> map) {
    return Hadith(
      id: map['id'] as int,
      chapterId: map['chapter_id'] as int,
      text: map['hadith_text'] as String,
      isFavorite: (map['is_favorite'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'hadith_text': text,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  Hadith copyWith({int? id, int? chapterId, String? text, bool? isFavorite}) {
    return Hadith(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      text: text ?? this.text,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
