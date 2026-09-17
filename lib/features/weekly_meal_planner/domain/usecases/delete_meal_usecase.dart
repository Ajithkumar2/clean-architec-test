import 'package:cchelper/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/meal_planner_repository.dart';

@lazySingleton
class DeleteMealUseCase {
  final MealPlannerRepository repository;

  DeleteMealUseCase(this.repository);

  Future<Either<Failure, void>> call(String mealId) async {
    return await repository.deleteMeal(mealId);
  }
}
