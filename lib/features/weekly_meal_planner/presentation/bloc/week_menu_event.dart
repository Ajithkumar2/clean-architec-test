import 'package:equatable/equatable.dart';
import '../../domain/entities/meal.dart';
import '../../domain/entities/meal_type.dart';

abstract class WeekMenuEvent extends Equatable {
  const WeekMenuEvent();

  @override
  List<Object?> get props => [];
}

class LoadWeekMenuEvent extends WeekMenuEvent {
  final DateTime? weekStart;

  const LoadWeekMenuEvent({this.weekStart});

  @override
  List<Object?> get props => [weekStart];
}

class ShiftWeekEvent extends WeekMenuEvent {
  final int deltaWeeks;

  const ShiftWeekEvent(this.deltaWeeks);

  @override
  List<Object?> get props => [deltaWeeks];
}

class SelectDateEvent extends WeekMenuEvent {
  final DateTime selectedDate;

  const SelectDateEvent(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}

class WeekChangedEvent extends WeekMenuEvent {
  final DateTime selectedDate;

  const WeekChangedEvent(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}

class AddMealEvent extends WeekMenuEvent {
  final Meal meal;

  const AddMealEvent(this.meal);

  @override
  List<Object?> get props => [meal];
}

class UpdateMealEvent extends WeekMenuEvent {
  final Meal meal;

  const UpdateMealEvent(this.meal);

  @override
  List<Object?> get props => [meal];
}

class DeleteMealEvent extends WeekMenuEvent {
  final String mealId;
  final DateTime date;
  final MealType mealType;

  const DeleteMealEvent(this.mealId, this.date, this.mealType);

  @override
  List<Object?> get props => [mealId, date, mealType];
}

class ToggleMealEditMode extends WeekMenuEvent {
  final String mealId;

  const ToggleMealEditMode(this.mealId);

  @override
  List<Object?> get props => [mealId];
}

class CancelMealEditEvent extends WeekMenuEvent {
  const CancelMealEditEvent();
}
