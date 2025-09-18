// import 'package:buck/themes/theme_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:buck/pages/settings.dart';
// import 'package:buck/pages/statistics.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final bool hasBackButton;

//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.hasBackButton = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = context.watch<ThemeProvider>();

//     return AppBar(
//       title: Text(
//         title,
//         style: TextStyle(
//           fontSize: 26,
//           fontWeight: FontWeight.bold,
//           color: themeProvider.themeData.colorScheme.onBackground,
//         ),
//       ),
//       centerTitle: true,
      
//       leading: hasBackButton
//           ? IconButton(
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: themeProvider.themeData.colorScheme.onBackground,
//               ),
//               onPressed: () => Navigator.of(context).pop(),
//             )
//           : null,
      
//       actions: [
//         PopupMenuButton<String>(
//           icon: Icon(
//             Icons.menu,
//             color: themeProvider.themeData.colorScheme.onBackground,
//           ),
//           itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//             // قائمة للوضع الليلي والنهاري
//             PopupMenuItem<String>(
//               value: 'theme',
//               child: StatefulBuilder(
//                 builder: (BuildContext context, StateSetter setState) {
//                   return SwitchListTile(
//                     title: Text(
//                       'الوضع الليلي',
//                       style: TextStyle(
//                         fontSize: themeProvider.fontSize,
//                         color: themeProvider.themeData.colorScheme.onSurface,
//                       ),
//                     ),
//                     value: themeProvider.themeData == ThemeData.dark(),
//                     onChanged: (bool value) {
//                       themeProvider.toggleTheme();
//                       setState(() {});
//                     },
//                     secondary: Icon(
//                       themeProvider.themeData == ThemeData.dark()
//                           ? Icons.light_mode
//                           : Icons.dark_mode,
//                       color: themeProvider.themeData.colorScheme.onSurface,
//                     ),
//                   );
//                 },
//               ),
//             ),
//             // قائمة للتحكم في حجم الخط
//             PopupMenuItem<String>(
//               value: 'font_size',
//               child: Column(
//                 children: [
//                   Text(
//                     'حجم الخط',
//                     style: TextStyle(
//                       fontSize: themeProvider.fontSize,
//                       color: themeProvider.themeData.colorScheme.onSurface,
//                     ),
//                   ),
//                   Slider(
//                     value: themeProvider.fontSize,
//                     min: 14.0,
//                     max: 24.0,
//                     divisions: 10,
//                     label: themeProvider.fontSize.round().toString(),
//                     onChanged: (double value) {
//                       themeProvider.setFontSize(value);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             // قائمة الانتقال إلى الإحصائيات
//             const PopupMenuItem<String>(
//               value: 'statistics',
//               child: Directionality(
//                 textDirection: TextDirection.rtl,
//                 child: Text('الإحصائيات'),
//               ),
//             ),
//             // قائمة الانتقال إلى الإعدادات
//             const PopupMenuItem<String>(
//               value: 'settings',
//               child: Directionality(
//                 textDirection: TextDirection.rtl,
//                 child: Text('الإعدادات'),
//               ),
//             ),
//           ],
//           onSelected: (String result) {
//             if (result == 'statistics') {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => const StatisticsPage()));
//             } else if (result == 'settings') {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
//             }
//           },
//         ),
//       ],
//       backgroundColor: themeProvider.themeData.colorScheme.background,
//       elevation: 5.0,
//       actionsPadding: const EdgeInsets.all(8),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
import 'package:flutter/material.dart';
import 'package:buck/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextEditingController? searchController;
  final bool hasSearch;

  const CustomAppBar({
    super.key,
    required this.title,
    this.searchController,
    this.hasSearch = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
        textDirection: TextDirection.rtl,
        
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
          icon: Icon(
            Provider.of<ThemeProvider>(context).isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
        ),
      ],
      bottom: hasSearch
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن حديث...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
