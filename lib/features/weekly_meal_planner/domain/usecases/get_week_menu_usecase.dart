import 'package:cchelper/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/day_menu.dart';
import '../repositories/meal_planner_repository.dart';

@lazySingleton
class GetWeekMenuUseCase {
  final MealPlannerRepository repository;

  GetWeekMenuUseCase(this.repository);

  Future<Either<Failure, Map<DateTime, DayMenu>>> call(DateTime weekStart) async {
    return await repository.getWeekMenu(weekStart);
  }
}
