import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/day_menu.dart';
import '../../domain/entities/meal.dart';
import '../../domain/usecases/delete_meal_usecase.dart';
import '../../domain/usecases/get_week_menu_usecase.dart';
import '../../domain/usecases/update_meal_usecase.dart';
import 'week_menu_event.dart';
import 'week_menu_state.dart';

@injectable
class WeekMenuBloc extends Bloc<WeekMenuEvent, WeekMenuState> {
  final GetWeekMenuUseCase getWeekMenuUseCase;
  final UpdateMealUseCase updateMealUseCase;
  final DeleteMealUseCase deleteMealUseCase;

  WeekMenuBloc({
    required this.getWeekMenuUseCase,
    required this.updateMealUseCase,
    required this.deleteMealUseCase,
  }) : super(WeekMenuState.initial()) {
    on<LoadWeekMenuEvent>(_onLoadWeekMenu);
    on<ShiftWeekEvent>(_onShiftWeek);
    on<SelectDateEvent>(_onSelectDate);
    on<WeekChangedEvent>(_onWeekChanged);
    on<AddMealEvent>(_onAddMeal);
    on<UpdateMealEvent>(_onUpdateMeal);
    on<DeleteMealEvent>(_onDeleteMeal);
    on<ToggleMealEditMode>(_onToggleMealEditMode);
    on<CancelMealEditEvent>(_onCancelMealEdit);
  }

  DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> _onLoadWeekMenu(
    LoadWeekMenuEvent event,
    Emitter<WeekMenuState> emit,
  ) async {
    final weekStart = _normalizeDate(event.weekStart ?? state.currentWeekStart);

    emit(state.copyWith(status: WeekMenuStatus.loading, errorMessage: null));

    final result = await getWeekMenuUseCase(weekStart);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: WeekMenuStatus.error,
          errorMessage: 'Failed to load meal plan. Please try again.',
        ));
      },
      (weekMenus) {
        final updatedMenus = Map<DateTime, DayMenu>.from(state.weeklyMenus)
          ..addAll(weekMenus);

        emit(state.copyWith(
          status: WeekMenuStatus.loaded,
          weeklyMenus: updatedMenus,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onShiftWeek(
    ShiftWeekEvent event,
    Emitter<WeekMenuState> emit,
  ) async {
    final newWeekStart = _normalizeDate(
      state.currentWeekStart.add(Duration(days: event.deltaWeeks * 7)),
    );
    final newWeekDates = List.generate(
      5,
      (index) => newWeekStart.add(Duration(days: index)),
    );

    // Keep the same day of week index (0 = Mon, 4 = Fri)
    int currentDayIndex = state.selectedDate.difference(state.currentWeekStart).inDays;
    if (currentDayIndex < 0 || currentDayIndex > 4) {
      currentDayIndex = 0;
    }
    final newSelectedDate = newWeekStart.add(Duration(days: currentDayIndex));

    emit(state.copyWith(
      currentWeekStart: newWeekStart,
      weekDates: newWeekDates,
      selectedDate: newSelectedDate,
    ));

    // Check if the new week's dates are already fully cached
    final allDatesCached = newWeekDates.every(
      (date) => state.weeklyMenus.containsKey(_normalizeDate(date)),
    );

    if (!allDatesCached) {
      add(LoadWeekMenuEvent(weekStart: newWeekStart));
    }
  }

  void _onSelectDate(
    SelectDateEvent event,
    Emitter<WeekMenuState> emit,
  ) {
    final normalizedDate = _normalizeDate(event.selectedDate);
    if (normalizedDate != state.selectedDate) {
      emit(state.copyWith(selectedDate: normalizedDate));

      // If the selected date isn't cached yet, fetch the week
      if (!state.weeklyMenus.containsKey(normalizedDate)) {
        add(LoadWeekMenuEvent(weekStart: state.currentWeekStart));
      }
    }
  }

  void _onWeekChanged(
    WeekChangedEvent event,
    Emitter<WeekMenuState> emit,
  ) {
    final normalizedDate = _normalizeDate(event.selectedDate);
    // Find Monday of the week containing the selected date
    final monday = normalizedDate.subtract(
      Duration(days: normalizedDate.weekday - DateTime.monday),
    );
    final newWeekDates = List.generate(
      5,
      (index) => monday.add(Duration(days: index)),
    );

    emit(state.copyWith(
      currentWeekStart: monday,
      weekDates: newWeekDates,
      selectedDate: normalizedDate,
    ));

    final allDatesCached = newWeekDates.every(
      (date) => state.weeklyMenus.containsKey(_normalizeDate(date)),
    );

    if (!allDatesCached) {
      add(LoadWeekMenuEvent(weekStart: monday));
    }
  }

  Future<void> _onAddMeal(
    AddMealEvent event,
    Emitter<WeekMenuState> emit,
  ) async {
    final result = await updateMealUseCase(event.meal);

    result.fold(
      (failure) {
        emit(state.copyWith(
          errorMessage: 'Failed to add meal. Please try again.',
        ));
      },
      (addedMeal) {
        final mealDate = _normalizeDate(addedMeal.date);
        final existingDayMenu = state.weeklyMenus[mealDate] ?? DayMenu(date: mealDate, meals: const []);

        final exists = existingDayMenu.meals.any((m) => m.id == addedMeal.id);
        final List<Meal> updatedMeals;
        if (exists) {
          updatedMeals = existingDayMenu.meals.map((m) => m.id == addedMeal.id ? addedMeal : m).toList();
        } else {
          updatedMeals = List<Meal>.from(existingDayMenu.meals)..add(addedMeal);
        }

        final updatedDayMenu = existingDayMenu.copyWith(meals: updatedMeals);
        final updatedWeeklyMenus = Map<DateTime, DayMenu>.from(state.weeklyMenus);
        updatedWeeklyMenus[mealDate] = updatedDayMenu;

        emit(state.copyWith(
          weeklyMenus: updatedWeeklyMenus,
          errorMessage: null,
          editingMealId: addedMeal.id,
        ));
      },
    );
  }

  Future<void> _onUpdateMeal(
    UpdateMealEvent event,
    Emitter<WeekMenuState> emit,
  ) async {
    final result = await updateMealUseCase(event.meal);

    result.fold(
      (failure) {
        emit(state.copyWith(
          errorMessage: 'Failed to update meal. Please try again.',
        ));
      },
      (updatedMeal) {
        final mealDate = _normalizeDate(updatedMeal.date);
        final existingDayMenu = state.weeklyMenus[mealDate] ?? DayMenu(date: mealDate, meals: const []);

        final exists = existingDayMenu.meals.any((m) => m.id == updatedMeal.id);
        final List<Meal> updatedMeals;
        if (exists) {
          updatedMeals = existingDayMenu.meals.map((meal) {
            return meal.id == updatedMeal.id ? updatedMeal : meal;
          }).toList();
        } else {
          updatedMeals = List<Meal>.from(existingDayMenu.meals)..add(updatedMeal);
        }

        final updatedDayMenu = existingDayMenu.copyWith(meals: updatedMeals);
        final updatedWeeklyMenus = Map<DateTime, DayMenu>.from(state.weeklyMenus);
        updatedWeeklyMenus[mealDate] = updatedDayMenu;

        emit(state.copyWith(
          weeklyMenus: updatedWeeklyMenus,
          errorMessage: null,
          clearEditingMealId: state.editingMealId == updatedMeal.id,
        ));
      },
    );
  }

  Future<void> _onDeleteMeal(
    DeleteMealEvent event,
    Emitter<WeekMenuState> emit,
  ) async {
    final result = await deleteMealUseCase(event.mealId);

    result.fold(
      (failure) {
        emit(state.copyWith(
          errorMessage: 'Failed to delete meal. Please try again.',
        ));
      },
      (_) {
        final mealDate = _normalizeDate(event.date);
        final existingDayMenu = state.weeklyMenus[mealDate];

        if (existingDayMenu != null) {
          final updatedMeals = existingDayMenu.meals.where((m) => m.id != event.mealId).toList();
          final updatedDayMenu = existingDayMenu.copyWith(meals: updatedMeals);
          final updatedWeeklyMenus = Map<DateTime, DayMenu>.from(state.weeklyMenus);
          updatedWeeklyMenus[mealDate] = updatedDayMenu;

          emit(state.copyWith(
            weeklyMenus: updatedWeeklyMenus,
            errorMessage: null,
            clearEditingMealId: state.editingMealId == event.mealId,
          ));
        }
      },
    );
  }

  void _onToggleMealEditMode(
    ToggleMealEditMode event,
    Emitter<WeekMenuState> emit,
  ) {
    if (state.editingMealId == event.mealId) {
      emit(state.copyWith(clearEditingMealId: true));
    } else {
      emit(state.copyWith(editingMealId: event.mealId));
    }
  }

  void _onCancelMealEdit(
    CancelMealEditEvent event,
    Emitter<WeekMenuState> emit,
  ) {
    emit(state.copyWith(clearEditingMealId: true));
  }
}
