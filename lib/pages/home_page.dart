import 'package:buck/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:buck/database_helper.dart';
import 'package:buck/models/chaper.dart'; // تم تصحيح اسم الملف
import 'package:buck/pages/hadith_list_page.dart'; // تم تصحيح اسم الاستيراد
import 'package:buck/models/hadith.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  late Future<List<Chapter>> _chapters;
  List<Hadith> _searchResults = [];
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _chapters = _dbHelper.getChapters();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _searchQuery = '';
      });
      return;
    }

    try {
      final results = await _dbHelper.searchHadiths(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _searchQuery = query;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في البحث: $e')));
    }
  }

  void _closeSearch() {
    setState(() {
      _searchResults = [];
      _searchQuery = '';
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'صحيح البخاري',
        onSearch: _performSearch,
        onSearchClosed: _closeSearch,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _isSearching || _searchQuery.isNotEmpty
          ? _buildSearchResults()
          : _buildChaptersList(),
    );
  }

  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) {
      return const Center(
        child: Text(
          'ابدأ البحث عن حديث',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لم يتم العثور على نتائج',
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'حاول البحث عن كلمة أخرى',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final hadith = _searchResults[index];
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            gradient: isDark
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1A2139).withOpacity(0.9),
                      const Color(0xFF0F1729).withOpacity(0.9),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF00695C).withOpacity(0.08),
                      const Color(0xFF00BFA5).withOpacity(0.08),
                    ],
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'الحديث رقم: ${hadith.id}',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hadith.text,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChaptersList() {
    return FutureBuilder<List<Chapter>>(
      future: _chapters,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No chapters found.'));
        }

        final chapters = snapshot.data!;
        return ListView.builder(
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            final chapter = chapters[index];
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                gradient: isDark
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1A2139).withOpacity(0.9),
                          const Color(0xFF0F1729).withOpacity(0.9),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF00695C).withOpacity(0.08),
                          const Color(0xFF00BFA5).withOpacity(0.08),
                        ],
                      ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 14.0,
                ),
                title: Text(
                  chapter.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                subtitle: Text(
                  'عدد الأحاديث: ${chapter.hadithCount}',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () {
                  // الانتقال إلى صفحة قائمة الأحاديث وإرسال كائن الفصل (Chapter) كاملاً
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HadithListPage(chapter: chapter),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
