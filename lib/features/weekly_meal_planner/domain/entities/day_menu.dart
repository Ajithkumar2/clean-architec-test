import 'package:equatable/equatable.dart';
import 'meal.dart';
import 'meal_type.dart';

class DayMenu extends Equatable {
  final DateTime date;
  final List<Meal> meals;

  const DayMenu({
    required this.date,
    required this.meals,
  });

  List<Meal> mealsFor(MealType type) {
    return meals.where((meal) => meal.type == type).toList();
  }

  List<Meal> get breakfastMeals => mealsFor(MealType.breakfast);
  List<Meal> get lunchMeals => mealsFor(MealType.lunch);
  List<Meal> get dinnerMeals => mealsFor(MealType.dinner);
  List<Meal> get snackMeals => mealsFor(MealType.snack);

  DayMenu copyWith({
    DateTime? date,
    List<Meal>? meals,
  }) {
    return DayMenu(
      date: date ?? this.date,
      meals: meals ?? this.meals,
    );
  }

  @override
  List<Object?> get props => [date, meals];
}
