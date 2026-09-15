import 'package:cchelper/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/meal.dart';
import '../repositories/meal_planner_repository.dart';

@lazySingleton
class UpdateMealUseCase {
  final MealPlannerRepository repository;

  UpdateMealUseCase(this.repository);

  Future<Either<Failure, Meal>> call(Meal meal) async {
    return await repository.updateMeal(meal);
  }
}
