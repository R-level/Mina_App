import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:mina_app/data/model/day.dart';
import 'package:mina_app/features/dashboard/view/dashboard_view.dart';
import 'package:mina_app/local_libraries/table_calendar/lib/table_calendar.dart';
import 'package:mina_app/local_libraries/table_calendar/lib/src/shared/utils.dart';
import 'period_picker_logic.dart';

/*A view of days that a user can choose to be a period day
//The purpose of this view is to clarify  the user's start and end days of their period
//and allow them to choose the days that they want to be a period day
//The interaction is triggered from the Day_Entry view upon tapping the 
// appropriate button. 
// The appropriate button [period_pick_trigger] on the Day_Entry view is determined by
// 2 factors, app state and the day the user is looking at. 
// The app state is determined by where in the 
// cycle the user is. The day is determined by the day the Day_Entry view is for.
// The Day entry UI will adjust to whether the day falls within the current cycle
// and whether the day is a period day or not.
For instance in the case of a Day falling in a previous cycle
 that is not a period day, the [period_pick_trigger] button will not exist.
The [period_pick_trigger] button is responsible for taking the user to this view. 
It will only appear for days that:
# are period start and end days within past menstrual cycles.
# are in the current cycle
    ->The [period_pick_trigger] will prompt user to choose a start period day if the current cycle state == PeriodEnded.
    ->The [period_pick_trigger] will prompt user to choose an end period day if the current cycle state == currentPeriodOngoing.
    ->The current cycle is demarcated by the latest periodStartday. Therefore upon saving 
      the entries in this view the currentperiodStartday will be updated to reflect the latest current cycle
      

*/
class PeriodDayPickerView extends StatefulWidget {
  @override
  _PeriodDayPickerViewState createState() => _PeriodDayPickerViewState();
}

/*
This view will display ranges of period days. These ranges will be populated by the user's selected 
period start and end days.
Using data from the database, this view will populate the list of days that are period days
The days will be displayed in a calendar view.
The user can manipulate the days by tapping on them.
The UI will respond to the user's interaction by updating 
the ranges that the displays.
 */
class _PeriodDayPickerViewState extends State<PeriodDayPickerView> {
  //An empty list for days that are period days
  Set<DateTime> selectedPeriodDateSet = {};
  //A list of days that are period days
  final Set<DateTime> oldPeriodDateSet = {};
  //A list for Period days that were unselected and need to be deleted
  final Set<DateTime> unselectedPeriodDateSet = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //Get the average period length

    //Get the days and populate oldPeriodSet
    _loadPeriodDays();
    // Scroll to a specific position upon page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(MediaQuery.of(context).size.height *
          0.45 *
          3); // Each month is 382 pixels
    });
  }

  void _loadPeriodDays() async {
    DateTime now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    List<Day> periodDays = await DatabaseHelper().getPeriodDaysInRange(
        DateTime(1960, 1, 1), DateTime(now.year + 1, now.month + 2, 0));
    // Use compute to process days in a background isolate
    final Set<DateTime> processed =
        await compute(_processPeriodDaySetIsolate, periodDays);
    setState(() {
      oldPeriodDateSet.clear();
      oldPeriodDateSet.addAll(processed);
      if (selectedPeriodDateSet.isEmpty) {
        selectedPeriodDateSet = {...processed};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final months = List<DateTime>.generate(
            (now.year - 1960) * 12 + now.month,
            (i) =>
                DateTime(1960 + i ~/ 12, 1 + i % 12, 1 + i ~/ 12 * 12 ~/ 12 * 0)
                    .add(Duration(days: 0)))
        .map((date) => DateTime(
            1960 + (date.month - 1 + date.year * 12 - 1960 * 12) ~/ 12,
            (date.month - 1 + date.year * 12 - 1960 * 12) % 12 + 1,
            1))
        .toList();

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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .map((d) => Expanded(
                              child: Center(
                                  child: Container(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              d,
                              style: const TextStyle(fontSize: 16),
                            ),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0, top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        }, //onPressed,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 42.0, vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          backgroundColor:
                              const Color.fromARGB(84, 33, 149, 243),
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Close",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        onPressed: () {
                          PeriodPicker periodPicker = PeriodPicker();
                          periodPicker.saveEditedDays(
                              selectedPeriodDateSet, oldPeriodDateSet);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DashboardView()));
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 42.0, vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          backgroundColor:
                              const Color.fromARGB(81, 243, 33, 180),
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )),
                  ),
                ],
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
          padding: EdgeInsets.all(12),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: totalGridCount,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemBuilder: (context, index) {
            if (index < startWeekday) return Container();

            final day = index - startWeekday + 1;
            final date = DateTime(month.year, month.month, day);
            var now = DateTime.now();
            final isFutureDay =
                date.isAfter(DateTime(now.year, now.month, now.day));
            var isSelected =
                selectedPeriodDateSet.contains(normalizeDate(date));

            return GestureDetector(
              onTap: () {
                if (!isFutureDay) {
                  setState(() {
                    if (isSelected) {
                      selectedPeriodDateSet.remove(normalizeDate(date));
                    } else {
                      selectedPeriodDateSet.add(normalizeDate(date));
                    }
                  });
                }
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
                                color: isFutureDay
                                    ? Colors.grey
                                    : isSelected
                                        ? const Color.fromARGB(255, 235, 43, 43)
                                        : Colors.black87,
                                fontWeight: FontWeight.w600,
                              )),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: isFutureDay
                                  ? Border.all(color: Colors.grey, width: 2)
                                  : isSelected
                                      ? Border.all(
                                          color: Colors.pinkAccent, width: 2)
                                      : Border.all(
                                          color: const Color.fromARGB(
                                              255, 116, 103, 107),
                                          width: 2),
                              color: isFutureDay
                                  ? Colors.grey.shade200
                                  : isSelected
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

  // Helper function for compute()
  static Set<DateTime> _processPeriodDaySetIsolate(List<Day> periodDays) {
    return periodDays
        .map((day) => DateTime(day.date.year, day.date.month, day.date.day))
        .toSet();
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
