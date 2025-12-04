import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:buck/components/usage_service.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with WidgetsBindingObserver {
  // الكود القديم
  List<DateTime> openedDays = [];
  int streak = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // تحميل البيانات القديمة (أيام + ستريك)
  Future<void> _loadData() async {
    final days = await UsageService.getAllDays();
    final s = await UsageService.getStreak();

    setState(() {
      openedDays = days;
      streak = s;
    });
  }

  bool _isOpenedDay(DateTime day) {
    return openedDays.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "الإحصائيات",
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // التقويم
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: DateTime.now(),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, _) {
                  if (_isOpenedDay(day)) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      child: Text(
                        "${day.day}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "$streak",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: streak > 0 ? Colors.green : Colors.red,
              ),
            ),
            const Text(
              "عدد الأيام المتتالية التي واظبت فيها على فتح التطبيق",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 40, thickness: 2),
          ],
        ),
      ),
    );
  }
}
