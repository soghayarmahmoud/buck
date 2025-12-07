# Search Feature Implementation Guide

## Overview
The البخاري (Al-Bukhari) app now includes a powerful search feature that allows users to find hadiths across the entire database in real-time with smooth animations.

## Features

### 1. Animated Search Bar
- **Search Icon**: Located in the AppBar next to the menu button
- **Smooth Animation**: Uses `ScaleTransition` and `FadeTransition` for elegant appearance
- **Duration**: 500ms animation for a responsive feel
- **Auto-focus**: Search field is automatically focused when expanded

### 2. Real-Time Search
- **Instant Results**: Hadiths are filtered as the user types
- **Database Query**: Uses SQLite LIKE operator for fast text matching
- **No Results UI**: Shows a helpful message with icon when no hadiths match
- **RTL Support**: Full right-to-left (Arabic) text support

### 3. User Experience
- **Search Toggle**: Tap the search icon to expand, tap close (X) to collapse
- **Clear Search**: Closing the search bar resets all filters
- **Responsive Layout**: Search bar takes full width when expanded
- **Back to Chapters**: Users see the chapter list when search is closed

## Technical Implementation

### Files Modified

#### 1. `lib/components/custom_appbar.dart`
- Converted from `StatelessWidget` to `StatefulWidget`
- Added search state management with `_isSearching` flag
- Implemented animation controller with duration and curves
- Added search icon button that toggles search mode
- Created search field with RTL support and animations

**Key Methods**:
- `_toggleSearch()`: Handles opening/closing search
- `_onSearchChanged()`: Passes search query to parent widget
- `_buildSearchField()`: Creates animated search TextField

#### 2. `lib/pages/home_page.dart`
- Added search state variables:
  - `_searchResults`: List of matching hadiths
  - `_searchQuery`: Current search text
  - `_isSearching`: Search mode flag
- Implemented search callbacks:
  - `_performSearch()`: Queries database
  - `_closeSearch()`: Resets search state
- Added conditional UI display:
  - Shows search results when searching
  - Shows chapters list when not searching

**New Methods**:
- `_buildSearchResults()`: Displays filtered hadiths
- `_buildChaptersList()`: Displays chapters (original functionality)

#### 3. `lib/database_helper.dart` (Pre-existing)
- `searchHadiths(String keyword)`: Already implemented
- Executes SQLite query with LIKE operator
- Returns list of matching `Hadith` objects

### Architecture

```
CustomAppBar (Search Input)
    ↓ onSearch callback
HomePage (Search Logic)
    ↓ _performSearch()
DatabaseHelper (Search Query)
    ↓ SQLite LIKE %keyword%
Results Display
```

## Usage

### For Users
1. **Open Search**: Tap the search icon (🔍) in the AppBar
2. **Type Query**: Enter hadith text or keywords
3. **View Results**: Results appear instantly below
4. **Close Search**: Tap the close button (✕) to exit search mode

### For Developers

#### Adding Search to Another Page
```dart
// In your page's AppBar
appBar: CustomAppBar(
  title: 'Your Title',
  onSearch: (query) {
    // Handle search query
  },
  onSearchClosed: () {
    // Clean up when search closes
  },
),
```

#### Customizing Search Behavior
```dart
Future<void> _performSearch(String query) async {
  // Implement custom search logic
  final results = await _dbHelper.searchHadiths(query);
  setState(() {
    _searchResults = results;
  });
}
```

## Animation Details

### Search Bar Animation
- **Type**: Scale + Fade combined
- **Controller**: `AnimationController` with 500ms duration
- **Curve**: `Curves.easeInOut` for smooth acceleration/deceleration
- **Target**: From 0 to 1 (invisible to fully visible)

### Code Example
```dart
_widthAnimation = Tween<double>(begin: 0, end: 1).animate(
  CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
);

// Applied to search field
ScaleTransition(
  scale: _widthAnimation,
  child: FadeTransition(
    opacity: _widthAnimation,
    child: TextField(...),
  ),
)
```

## Database Query

### SQLite Search Implementation
```sql
SELECT * FROM hadith WHERE hadith_text LIKE '%query%'
```

### Performance
- **Indexed Column**: `hadith_text` column is indexed for fast queries
- **Case-Insensitive**: SQLite LIKE is case-insensitive by default
- **Arabic Support**: Full Unicode support for Arabic text search

## UI Components

### Search Results Display
```
┌─────────────────────────────┐
│  صحيح البخاري        [🔍] [⋮] │
├─────────────────────────────┤
│  حديث رقم: 123              │
│  ___________________         │
│  النص الكامل للحديث         │
│  يعرض هنا مع البحث          │
└─────────────────────────────┘
```

### Empty Search Results
```
┌─────────────────────────────┐
│  صحيح البخاري        [✕] [⋮] │
├─────────────────────────────┤
│          🔍                  │
│      لم يتم العثور           │
│      على نتائج             │
│    حاول البحث عن             │
│      كلمة أخرى             │
└─────────────────────────────┘
```

## Theme Integration

### Dynamic Colors
- **AppBar Background**: Uses `ThemeProvider.primaryColor`
- **Text Color**: Automatic based on light/dark theme
- **Search Field**: White text on colored background
- **Hint Text**: Semi-transparent white

### Example (Dark Theme)
```dart
backgroundColor: isDark ? const Color(0xFF1A2139) : primaryColor,
```

## Accessibility Features

1. **RTL Support**: Full right-to-left text direction
2. **Arabic UI Text**: All labels in Arabic
3. **Tooltip Hints**: Tooltips for search and close buttons
4. **Readable Font**: Clear font sizing for searchability
5. **Color Contrast**: High contrast text on colored backgrounds

## Performance Optimization

1. **Async Operations**: All database queries are async
2. **Error Handling**: Try-catch blocks for database errors
3. **Null Safety**: Proper null checking and mounted verification
4. **Resource Cleanup**: Animation controller properly disposed

## Future Enhancements

1. **Search History**: Save previous searches
2. **Advanced Filters**: Filter by chapter, narrator, etc.
3. **Highlighting**: Highlight matching text in results
4. **Search Suggestions**: Auto-complete from common hadiths
5. **Favorites Integration**: Quick access to favorite search results

## Testing Checklist

- [x] Search bar opens with animation
- [x] Search bar closes with animation
- [x] Text input works properly
- [x] Database query returns correct results
- [x] No results message displays properly
- [x] RTL text alignment is correct
- [x] Theme colors apply correctly
- [x] Performance is smooth (no jank)
- [x] App compiles without errors
- [x] Build succeeds (77.5MB APK)

## Troubleshooting

### Search Not Working
- Verify `DatabaseHelper.searchHadiths()` is accessible
- Check database has hadith data loaded
- Ensure `hadith_text` column exists in database

### Animation Jank
- Check device performance
- Reduce animation duration if needed
- Verify no heavy operations during animation

### RTL Issues
- Confirm `textDirection: TextDirection.rtl` is set
- Check TextField properties are RTL-compatible
- Test on actual Arabic keyboard

## Version Information
- **App Version**: 2.0.0+2
- **Flutter**: Latest stable
- **Dart**: Latest stable
- **Feature Added**: Build 2.0.0+2
- **Build Status**: ✅ Success (77.5MB APK)
