import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buck/providers/favorit_provider.dart';
import 'package:buck/database_helper.dart';
import 'package:buck/components/custom_appbar.dart';
import 'package:buck/models/hadith.dart';
import 'package:buck/components/hadith_card.dart'; // تأكد من استيراد HadithCard
import 'package:buck/pages/hadith_list_page.dart'; // تأكد من استيراد HadithsListPage

class FavoritePage extends StatelessWidget {
   const FavoritePage({super.key});

   @override
   Widget build(BuildContext context) {
      return Scaffold(
         appBar: const CustomAppBar(title: 'المفضلة'),
         body: Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
               return FutureBuilder<List<Hadith>>(
                  future: DatabaseHelper.instance.getFavoriteHadiths(),
                  builder: (context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                     }
                     if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                     }
                     final favoriteHadiths = snapshot.data ?? [];
                     if (favoriteHadiths.isEmpty) {
                        return const Center(
                           child: Text(
                              'لا يوجد أحاديث في المفضلة',
                              style: TextStyle(fontSize: 18),
                           ),
                        );
                     }
                     return Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView.builder(
                           itemCount: favoriteHadiths.length,
                           itemBuilder: (context, index) {
                              final hadith = favoriteHadiths[index];
                              return HadithCard(
                                 hadith: hadith,
                                 onTap: () async {
                                    final chapter = await DatabaseHelper.instance
                                          .getChapterById(hadith.chapterId);

                                    if (chapter != null && context.mounted) {
                                       Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                             builder: (context) => HadithListPage(
                                                chapter: chapter,
                                                
                                             ),
                                          ),
                                       );
                                    }
                                 });
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
