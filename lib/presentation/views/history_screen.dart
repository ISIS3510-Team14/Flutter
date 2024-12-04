import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/utils/sustainu_colors.dart';
import '../widgets/head.dart';
import '../widgets/bottom_navbar.dart';
import '../../data/services/firestore_service.dart';
import '../../data/services/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  List<DateTime> entryDates = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();

    loadData();
  }

  Future<void> loadData() async {
    try {
      final credentials = await _storageService.getUserCredentials();
      final entries =
          await _firestoreService.fetchHistoryEntries(credentials?['email']);
      print(entries);

      setState(() {
        entryDates = entries;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  bool _hasEntry(DateTime day) {
    return entryDates.any((entryDate) => isSameDay(entryDate, day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SustainUColors.background,
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
              child: HeaderWidget(),
            ),
            SizedBox(height: 20),
            Text(
              "Your Recycling History",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: SustainUColors.text,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TableCalendar(
                firstDay: DateTime(2023, 1, 1),
                lastDay: DateTime(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: SustainUColors.limeGreen,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: SustainUColors.text),
                  weekendStyle: TextStyle(color: SustainUColors.text),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: SustainUColors.text,
                  ),
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: SustainUColors.text),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: SustainUColors.text),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    if (_hasEntry(day)) {
                      return Container(
                        decoration: BoxDecoration(
                          color: SustainUColors.limeGreen,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return null;
                  },
                  todayBuilder: (context, day, focusedDay) {
                    if (_hasEntry(day)) {
                      return Container(
                        decoration: BoxDecoration(
                          color: SustainUColors.lightBlue,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return null;
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
