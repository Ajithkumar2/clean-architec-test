import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/week_menu_bloc.dart';
import '../bloc/week_menu_event.dart';
import '../bloc/week_menu_state.dart';

class _DateSelectorData {
  final List<DateTime> weekDates;
  final DateTime selectedDate;

  const _DateSelectorData({
    required this.weekDates,
    required this.selectedDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _DateSelectorData &&
          runtimeType == other.runtimeType &&
          _areDatesEqual(weekDates, other.weekDates) &&
          selectedDate == other.selectedDate;

  @override
  int get hashCode => Object.hash(Object.hashAll(weekDates), selectedDate);

  static bool _areDatesEqual(List<DateTime> a, List<DateTime> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class WeekDateSelector extends StatelessWidget {
  const WeekDateSelector({super.key});

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  String _formatWeekRange(List<DateTime> dates) {
    if (dates.isEmpty) return '';
    final first = dates.first;
    final last = dates.last;
    final firstMonth = _monthNames[first.month - 1];
    final lastMonth = _monthNames[last.month - 1];

    if (firstMonth == lastMonth) {
      return '$firstMonth ${first.day} – ${last.day}, ${first.year}';
    } else {
      return '$firstMonth ${first.day} – $lastMonth ${last.day}, ${first.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<WeekMenuBloc, WeekMenuState, _DateSelectorData>(
      selector: (state) => _DateSelectorData(
        weekDates: state.weekDates,
        selectedDate: state.selectedDate,
      ),
      builder: (context, data) {
        final weekDates = data.weekDates;
        final selectedDate = data.selectedDate;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Week navigation header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      tooltip: 'Previous week',
                      onPressed: () {
                        context.read<WeekMenuBloc>().add(const ShiftWeekEvent(-1));
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                          helpText: 'Select week',
                        );
                        if (pickedDate != null && context.mounted) {
                          context.read<WeekMenuBloc>().add(WeekChangedEvent(pickedDate));
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatWeekRange(weekDates),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_drop_down_rounded,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      tooltip: 'Next week',
                      onPressed: () {
                        context.read<WeekMenuBloc>().add(const ShiftWeekEvent(1));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Mon-Fri date chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(weekDates.length, (index) {
                    final date = weekDates[index];
                    final isSelected = date.year == selectedDate.year &&
                        date.month == selectedDate.month &&
                        date.day == selectedDate.day;

                    return _DateChip(
                      dayName: _dayNames[index],
                      dayNumber: '${date.day}',
                      isSelected: isSelected,
                      onTap: () {
                        context.read<WeekMenuBloc>().add(SelectDateEvent(date));
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DateChip extends StatelessWidget {
  final String dayName;
  final String dayNumber;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateChip({
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dayNumber,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
