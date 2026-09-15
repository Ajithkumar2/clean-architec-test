import 'package:equatable/equatable.dart';
import '../../domain/entities/day_menu.dart';

enum WeekMenuStatus { initial, loading, loaded, error }

class WeekMenuState extends Equatable {
  final WeekMenuStatus status;
  final DateTime currentWeekStart;
  final List<DateTime> weekDates;
  final DateTime selectedDate;
  final Map<DateTime, DayMenu> weeklyMenus;
  final String? errorMessage;
  final String? editingMealId;

  const WeekMenuState({
    required this.status,
    required this.currentWeekStart,
    required this.weekDates,
    required this.selectedDate,
    required this.weeklyMenus,
    this.errorMessage,
    this.editingMealId,
  });

  factory WeekMenuState.initial({DateTime? now}) {
    final today = now ?? DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    // Find Monday of the current week (weekday: Mon=1, ..., Sun=7)
    final monday = normalizedToday.subtract(Duration(days: normalizedToday.weekday - DateTime.monday));
    final weekDates = List.generate(5, (index) => monday.add(Duration(days: index)));

    // If today is Mon-Fri, select today; otherwise select Monday
    DateTime initialSelected = monday;
    if (normalizedToday.weekday >= DateTime.monday && normalizedToday.weekday <= DateTime.friday) {
      initialSelected = normalizedToday;
    }

    return WeekMenuState(
      status: WeekMenuStatus.initial,
      currentWeekStart: monday,
      weekDates: weekDates,
      selectedDate: initialSelected,
      weeklyMenus: const {},
      errorMessage: null,
      editingMealId: null,
    );
  }

  DayMenu? get selectedDayMenu {
    final normalizedSelected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    return weeklyMenus[normalizedSelected];
  }

  WeekMenuState copyWith({
    WeekMenuStatus? status,
    DateTime? currentWeekStart,
    List<DateTime>? weekDates,
    DateTime? selectedDate,
    Map<DateTime, DayMenu>? weeklyMenus,
    String? errorMessage,
    String? editingMealId,
    bool clearEditingMealId = false,
  }) {
    return WeekMenuState(
      status: status ?? this.status,
      currentWeekStart: currentWeekStart ?? this.currentWeekStart,
      weekDates: weekDates ?? this.weekDates,
      selectedDate: selectedDate ?? this.selectedDate,
      weeklyMenus: weeklyMenus ?? this.weeklyMenus,
      errorMessage: errorMessage ?? this.errorMessage,
      editingMealId: clearEditingMealId ? null : (editingMealId ?? this.editingMealId),
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentWeekStart,
        weekDates,
        selectedDate,
        weeklyMenus,
        errorMessage,
        editingMealId,
      ];
}
