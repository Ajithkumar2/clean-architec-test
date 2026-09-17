import 'package:cchelper/core/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/day_menu.dart';
import '../entities/meal.dart';

abstract class MealPlannerRepository {
  Future<Either<Failure, Map<DateTime, DayMenu>>> getWeekMenu(DateTime weekStart);
  Future<Either<Failure, Meal>> updateMeal(Meal meal);
  Future<Either<Failure, void>> deleteMeal(String mealId);
}
