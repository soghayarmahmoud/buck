class Chapter {
  final int id;
  final String title;
  final int hadithCount;

  Chapter({
    required this.id,
    required this.title,
    required this.hadithCount,
  });

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'],
      title: map['title'],
      hadithCount: map['hadith_count'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'hadith_count': hadithCount,
    };
  }
}
