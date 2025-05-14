import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeriodDayPickerView extends StatefulWidget {
  @override
  _PeriodDayPickerViewState createState() => _PeriodDayPickerViewState();
}

class _PeriodDayPickerViewState extends State<PeriodDayPickerView> {
  final Set<DateTime> selectedDates = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Scroll to a specific position upon page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(MediaQuery.of(context).size.height *
          0.45 *
          7); // Each month is 382 pixels
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = List.generate(12, (i) => DateTime(now.year, i + 1, 1));

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          title: Container(
            child: Column(
              children: [
                Text('My period started'),
                Text(
                    '${DateFormat.E().format(now)}, ${DateFormat.MMMd().format(now)}',
                    style: const TextStyle(fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .map((d) => Expanded(
                              child: Center(
                                  child: Text(
                            d,
                            style: const TextStyle(fontSize: 16),
                          ))))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: months.length,
                itemBuilder: (context, index) {
                  final month = months[index];
                  return buildMonthCalendar(month);
                },
              ),
            ),
          ],
        ));
  }

  Widget buildMonthCalendar(DateTime month) {
    final days = daysInMonth(month);
    final startWeekday = DateTime(month.year, month.month, 1).weekday % 7;
    final totalGridCount = startWeekday + days;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            DateFormat.yMMMM().format(month),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: totalGridCount,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemBuilder: (context, index) {
            if (index < startWeekday) return Container();

            final day = index - startWeekday + 1;
            final date = DateTime(month.year, month.month, day);
            final isSelected = selectedDates.contains(date);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedDates.remove(date);
                  } else {
                    selectedDates.add(date);
                  }
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRect(
                    //Add a custom clipper here
                    child: Container(
                        //Add decorations here
                        ),
                  ),
                  Center(
                    child: Container(
                      child: Column(
                        children: [
                          Text('$day',
                              style: TextStyle(
                                color: isSelected
                                    ? const Color.fromARGB(255, 235, 43, 43)
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                              )),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: isSelected
                                  ? Border.all(
                                      color: Colors.pinkAccent, width: 2)
                                  : Border.all(
                                      color: const Color.fromARGB(
                                          255, 116, 103, 107),
                                      width: 2),
                              color: isSelected
                                  ? Colors.pinkAccent
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                isSelected ? Icons.check : null,
                                color: isSelected ? Colors.white : Colors.black,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
      ],
    );
  }

  int daysInMonth(DateTime month) {
    final beginningNextMonth = (month.month == 12)
        ? DateTime(month.year + 1, 1, 1)
        : DateTime(month.year, month.month + 1, 1);
    return beginningNextMonth.subtract(Duration(days: 1)).day;
  }
}

class CustomRectClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.55),
        width: size.width,
        height: size.height * 0.4);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}

class CustomRectLeftClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
        center: Offset(size.width, size.height * 0.55),
        width: size.width,
        height: size.height * 0.4);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}

class CustomRectRightClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
        center: Offset(-size.width, size.height * 0.55),
        width: size.width,
        height: size.height * 0.4);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}

class AutoScrollGridView extends StatefulWidget {
  @override
  _AutoScrollGridViewState createState() => _AutoScrollGridViewState();
}

class _AutoScrollGridViewState extends State<AutoScrollGridView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Scroll to a specific position upon page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(150.0); // Example: Jump to 200 pixels
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Scroll GridView'),
      ),
      body: GridView.builder(
        controller: _scrollController, // Attach the ScrollController
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: 1.0,
        ),
        itemCount: 100, // Total number of items
        itemBuilder: (context, index) {
          return Container(
            color: Colors.blue[(index % 9 + 1) * 100],
            child: Center(
              child: Text(
                'Item $index',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
