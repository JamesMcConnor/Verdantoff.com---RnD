import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  // Sample schedule items with specified dates.
  // Each item includes a date, title, and time.
  final List<Map<String, dynamic>> scheduleItems = [
    {
      'date': DateTime.now(),
      'title': 'Team Meeting',
      'time': '10:00 AM',
    },
    {
      'date': DateTime.now(),
      'title': 'code meeting',
      'time': '2:00 PM',
    },
    {
      'date': DateTime.now(),
      'title': 'Team quick Meeting',
      'time': '8:00 PM',
    },
    {
      'date': DateTime.now().add(Duration(days: 1)),
      'title': 'Mentor Meeting',
      'time': '10:00 AM',
    },
    {
      'date': DateTime.now().add(Duration(days: 1)),
      'title': 'Project Planning',
      'time': '12:00 AM',
    },
    {
      'date': DateTime.now().subtract(Duration(days: 1)),
      'title': 'Code Review',
      'time': '3:30 PM',
    },
  ];

  // For a vertically scrolling calendar, we use a PageView.
  // We set an arbitrary initial page such that this page represents "today".
  final int initialPage = 1000;
  late PageController _pageController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: initialPage);
    selectedDate = DateTime.now();
  }

  // Given a page index, calculate the corresponding date.
  DateTime getDateFromPage(int page) {
    int difference = page - initialPage;
    return DateTime.now().add(Duration(days: difference));
  }

  // Format a date as "Day, Month Date, Year" (e.g., "Monday, Jul 20, 2025")
  String formatDate(DateTime date) {
    return DateFormat('EEEE, MMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (page) {
          setState(() {
            selectedDate = getDateFromPage(page);
          });
        },
        itemBuilder: (context, index) {
          DateTime date = getDateFromPage(index);
          // Filter schedule items to only include those that match the current date.
          List<Map<String, dynamic>> itemsForDate = scheduleItems.where((item) {
            DateTime itemDate = item['date'];
            return itemDate.year == date.year &&
                itemDate.month == date.month &&
                itemDate.day == date.day;
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the formatted date at the top.
                Text(
                  formatDate(date),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // Reserved space for today's schedule.
                Text(
                  "Today's Schedule",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: itemsForDate.isNotEmpty
                      ? ListView.builder(
                    itemCount: itemsForDate.length,
                    itemBuilder: (context, idx) {
                      var schedule = itemsForDate[idx];
                      return Card(
                        child: ListTile(
                          title: Text(schedule['title']),
                          subtitle: Text(schedule['time']),
                        ),
                      );
                    },
                  )
                      : Center(
                    child: Text('No schedule for this day'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // Floating action button to add a new schedule (placeholder functionality).
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add schedule action here.
          print('Add schedule button pressed');
        },
        tooltip: 'Add Schedule',
        child: Icon(Icons.add),
      ),
    );
  }
}
