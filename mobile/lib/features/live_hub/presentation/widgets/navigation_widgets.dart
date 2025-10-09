import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/football_bloc.dart';
import '../bloc/football_event.dart';
import '../bloc/football_state.dart';

class DateNavigationBar extends StatefulWidget {
  final bool showCalendar;
  final DateTime selectedDate;
  final VoidCallback onCalendarToggle;

  const DateNavigationBar({
    super.key,
    required this.showCalendar,
    required this.selectedDate,
    required this.onCalendarToggle,
  });

  @override
  State<DateNavigationBar> createState() => _DateNavigationBarState();
}

class _DateNavigationBarState extends State<DateNavigationBar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  String _getDisplayDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(widget.selectedDate.year,
        widget.selectedDate.month, widget.selectedDate.day);

    if (selectedDay == today) {
      return 'Today';
    } else if (selectedDay == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (selectedDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${_getMonthName(selectedDay.month)} ${selectedDay.day}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final selectedLeague = context.select((FootballBloc bloc) =>
        bloc.state is FootballLoaded
            ? (bloc.state as FootballLoaded).selectedLeague
            : 'ETH');

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: widget.onCalendarToggle,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (context) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final isSmallScreen = screenWidth < 360;
                      final buttonFontSize = isSmallScreen ? 14.0 : 16.0;

                      return Text(
                        widget.showCalendar
                            ? 'Close Calendar'
                            : _getDisplayDate(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    widget.showCalendar
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class CalendarOverlay extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime currentMonth;
  final Function(DateTime) onDateSelected;
  final Function(DateTime) onMonthChanged;
  final Function(String) onLeagueChanged;
  final String selectedLeague;
  final VoidCallback onClose;

  const CalendarOverlay({
    super.key,
    required this.selectedDate,
    required this.currentMonth,
    required this.onDateSelected,
    required this.onMonthChanged,
    required this.onLeagueChanged,
    required this.selectedLeague,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E7D32), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Calendar Header with Close Button
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => onMonthChanged(
                      DateTime(currentMonth.year, currentMonth.month - 1)),
                  child: const Icon(Icons.arrow_back_ios,
                      color: Color(0xFF2E7D32), size: 18),
                ),
                Builder(
                  builder: (context) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final isSmallScreen = screenWidth < 360;
                    final monthYearFontSize = isSmallScreen ? 16.0 : 18.0;

                    return Text(
                      '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
                      style: TextStyle(
                        fontSize: monthYearFontSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => onMonthChanged(
                          DateTime(currentMonth.year, currentMonth.month + 1)),
                      child: const Icon(Icons.arrow_forward_ios,
                          color: Color(0xFF2E7D32), size: 18),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onClose,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E7D32),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Calendar Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Days of week header
                const Row(
                  children: [
                    Expanded(
                        child: Center(
                            child: Text('Sun',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF666666))))),
                    Expanded(
                        child: Center(
                            child: Text('Mon',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF666666))))),
                    Expanded(
                        child: Center(
                            child: Text('Tue',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF666666))))),
                    Expanded(
                        child: Center(
                            child: Text('Wed',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF666666))))),
                    Expanded(
                        child: Center(
                            child: Text('Thu',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF666666))))),
                    Expanded(
                        child: Center(
                            child: Text('Fri',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF666666))))),
                    Expanded(
                        child: Center(
                            child: Text('Sat',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF666666))))),
                  ],
                ),
                const SizedBox(height: 8),
                // Calendar dates
                ..._buildCalendarGrid(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // League Selection
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color(0xFFE8F5E8), width: 1)),
            ),
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final isSmallScreen = screenWidth < 360;
                    final selectLeagueFontSize = isSmallScreen ? 14.0 : 16.0;

                    return Text(
                      'Select League',
                      style: TextStyle(
                        fontSize: selectLeagueFontSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LeagueButton(
                        title: 'Ethiopian Premier League',
                        isSelected: selectedLeague == 'ETH',
                        onTap: () => onLeagueChanged('ETH'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LeagueButton(
                        title: 'English Premier League',
                        isSelected: selectedLeague == 'EPL',
                        onTap: () => onLeagueChanged('EPL'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Convert to Sunday = 0

    final List<Widget> rows = [];
    List<Widget> currentRow = [];

    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstWeekday; i++) {
      currentRow.add(const Expanded(child: SizedBox(height: 40)));
    }

    // Add days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final isSelected = date.day == selectedDate.day &&
          date.month == selectedDate.month &&
          date.year == selectedDate.year;
      final isToday = date.day == DateTime.now().day &&
          date.month == DateTime.now().month &&
          date.year == DateTime.now().year;

      currentRow.add(
        Expanded(
          child: GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2E7D32)
                    : isToday
                        ? const Color(0xFFE8F5E8)
                        : Colors.transparent,
                shape: BoxShape.circle,
                border: isToday && !isSelected
                    ? Border.all(color: const Color(0xFF2E7D32), width: 1)
                    : null,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? Colors.white
                        : isToday
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF666666),
                    fontWeight: isSelected || isToday
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Start new row every 7 days
      if (currentRow.length == 7) {
        rows.add(Row(children: currentRow));
        currentRow = [];
      }
    }

    // Add remaining empty cells to complete the last row
    while (currentRow.length < 7 && currentRow.isNotEmpty) {
      currentRow.add(const Expanded(child: SizedBox(height: 40)));
    }

    if (currentRow.isNotEmpty) {
      rows.add(Row(children: currentRow));
    }

    return rows;
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

class LeagueButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const LeagueButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7D32) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Builder(
          builder: (context) {
            final screenWidth = MediaQuery.of(context).size.width;
            final isSmallScreen = screenWidth < 360;
            final buttonFontSize = isSmallScreen ? 10.0 : 12.0;

            return Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: buttonFontSize,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF666666),
              ),
            );
          },
        ),
      ),
    );
  }
}
