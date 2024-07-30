import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:srt_app/str/constants/calendar_constant.dart';

class SMEHorizontalCalendar extends StatefulWidget {
  final Color selectedColor;

  SMEHorizontalCalendar({
    required this.selectedColor,
  });

  @override
  _SMEHorizontalCalendarState createState() => _SMEHorizontalCalendarState();
}

class _SMEHorizontalCalendarState extends State<SMEHorizontalCalendar> {
  // var userController = Get.put(UserController());

  // TO tracking date
  DateTime selectedDate = DateTime.now();

  // Date of month
  late int dayOfMonth;

  // For Horizontal Month
  late int currentMonthPrev;
  late int currentMonthSelectedIndex;
  late int currentMonthNext;

  // For Horizontal Date
  int currentDateSelectedIndex = DateTime.now().day - 1;

  // To Track Scroll Date of ListView
  final ItemScrollController _itemScrollController = new ItemScrollController();
  late double _scrollAlignment;

  // List Month
  Map<int, String> listMonth = {};

  _SMEHorizontalCalendarState() {
    _getMonth();
    // userController.selectedDate.value =
        DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  @override
  void initState() {
    dayOfMonth = selectedDate.day;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _moveToDayIndex(currentDateSelectedIndex),
    );
  }

  void setCurrentYearMonth(year, month) {
    if (year == DateTime.now().year && month == DateTime.now().month) {
      setState(() {
        dayOfMonth = DateTime.now().day;
        updateSelectedDate(year);
      });
    } else {
      setState(() {
        dayOfMonth = daysInMonth(year, month);
        updateSelectedDate(year);
      });
    }
    _moveToDayIndex(currentDateSelectedIndex);
  }

  void _moveToDayIndex(int index) {
    _itemScrollController.scrollTo(
      index: index,
      alignment: _scrollAlignment,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  void updateSelectedDate(year) {
    selectedDate = new DateTime(
      year,
      currentMonthSelectedIndex,
      currentDateSelectedIndex + 1,
    );
    // userController.selectedDate.value =
        DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    _scrollAlignment = 10 / MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                _prevMonth();
              },
              child: Icon(Icons.chevron_left),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  listMonth.containsKey(currentMonthPrev)
                      ? GestureDetector(
                          onTap: () {
                            _prevMonth();
                          },
                          child: Text(
                            listMonth[currentMonthPrev].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  listMonth.containsKey(selectedDate.month)
                      ? Text(
                          listMonth[selectedDate.month].toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : SizedBox.shrink(),
                  listMonth.containsKey(currentMonthNext)
                      ? GestureDetector(
                          onTap: () {
                            _nextMonth();
                          },
                          child: Text(
                            listMonth[currentMonthNext].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _nextMonth();
              },
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 80,
          child: Container(
            child: ScrollablePositionedList.builder(
              scrollDirection: Axis.horizontal,
              itemScrollController: _itemScrollController,
              initialAlignment: _scrollAlignment,
              itemCount: dayOfMonth,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        currentDateSelectedIndex = index;
                        updateSelectedDate(selectedDate.year);
                      });
                      _moveToDayIndex(index);
                      // userController.fetchTimestamp(date: selectedDate);
                    },
                    child: Container(
                      height: 80,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: currentDateSelectedIndex == index
                            ? widget.selectedColor
                            : _getWeekday(index).contains("Sat") ||
                                    _getWeekday(index).contains("Sun")
                                ? Colors.grey.shade200
                                : Colors.grey.shade100,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getWeekday(index),
                            style: TextStyle(
                              fontSize: 16,
                              color: currentDateSelectedIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: currentDateSelectedIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _getWeekday(int index) {
    DateTime result =
        new DateTime(selectedDate.year, currentMonthSelectedIndex, index + 1);
    return DateFormat('EEEE').format(result).substring(0, 3);
  }

  void _getMonth({int beforeCurrentMonth = 3, int afterCurrentMonth = 3}) {
    for (int i = 0; i < beforeCurrentMonth; i++) {
      var prevMonth = new DateTime(
          selectedDate.year, (selectedDate.month - (i + 1)), selectedDate.day);
      listMonth[prevMonth.month] =
          listOfMonths[prevMonth.month - 1] + ", " + prevMonth.year.toString();
    }
    listMonth = LinkedHashMap.fromEntries(listMonth.entries.toList().reversed);
    listMonth[selectedDate.month] = listOfMonths[selectedDate.month - 1] +
        ", " +
        selectedDate.year.toString();

    currentMonthPrev = selectedDate.month - 1 < 1 ? 12 : selectedDate.month - 1;
    currentMonthSelectedIndex = selectedDate.month;
    currentMonthNext = selectedDate.month + 1 > 12 ? 1 : selectedDate.month + 1;

    // for (int i = 0; i < afterCurrentMonth; i++) {
    //   var nextMonth = new DateTime(
    //       selectedDate.year, selectedDate.month + (i + 1), selectedDate.day);
    //   listMonth[nextMonth.month] =
    //       listOfMonths[nextMonth.month - 1] + ", " + nextMonth.year.toString();
    // }
  }

  void _prevMonth() {
    var selectedMonth =
        (selectedDate.month - 1) < 1 ? 12 : selectedDate.month - 1;
    if (listMonth.containsKey(selectedMonth)) {
      var month = selectedDate.month - 1 < 1 ? 12 : selectedDate.month - 1;
      var yearStr =
          listMonth[(selectedDate.month - 1) < 1 ? 12 : selectedDate.month - 1]
              .toString();
      var year = yearStr.substring(yearStr.length - 4);
      setState(() {
        currentMonthPrev = month - 1 < 1 ? 12 : month - 1;
        currentMonthSelectedIndex = month;
        currentMonthNext = month + 1 > 12 ? 1 : month + 1;
        setCurrentYearMonth(int.parse(year), currentMonthSelectedIndex);
      });
      // userController.fetchTimestamp(date: selectedDate);
    }
  }

  void _nextMonth() {
    var selectedMonth =
        (selectedDate.month + 1) > 12 ? 1 : selectedDate.month + 1;
    if (listMonth.containsKey(selectedMonth)) {
      var month = selectedDate.month + 1 > 12 ? 1 : selectedDate.month + 1;
      var yearStr =
          listMonth[(selectedDate.month + 1) > 12 ? 1 : selectedDate.month + 1]
              .toString();
      var year = yearStr.substring(yearStr.length - 4);
      setState(() {
        currentMonthPrev = month - 1 < 1 ? 12 : month - 1;
        currentMonthSelectedIndex = month;
        currentMonthNext = month + 1 > 12 ? 1 : month + 1;
        setCurrentYearMonth(int.parse(year), currentMonthSelectedIndex);
      });
      // userController.fetchTimestamp(date: selectedDate);
    }
  }
}
