  import 'package:buck/components/custom_appbar.dart';
  import 'package:flutter/material.dart';
  import 'package:buck/database_helper.dart';
  import 'package:buck/models/chaper.dart'; // تم تصحيح اسم الملف
  import 'package:buck/pages/hadith_list_page.dart'; // تم تصحيح اسم الاستيراد

  class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    final DatabaseHelper _dbHelper = DatabaseHelper.instance;
    late Future<List<Chapter>> _chapters;

    @override
    void initState() {
      super.initState();
      _chapters = _dbHelper.getChapters();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'صحيح البخاري'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: FutureBuilder<List<Chapter>>(
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
                return Card(
                  color: Theme.of(context).cardColor,
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 6.0,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    title: Text(
                      chapter.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textDirection: TextDirection.rtl,
                    ),
                    subtitle: Text(
                      'عدد الأحاديث: ${chapter.hadithCount}',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // الانتقال إلى صفحة قائمة الأحاديث وإرسال كائن الفصل (Chapter) كاملاً
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HadithListPage(
                            chapter: chapter,
                          ),
                        ),
                      );
                    },
                  ),
                );  
              },
            );
          },
        ),
      );
    }
  }
