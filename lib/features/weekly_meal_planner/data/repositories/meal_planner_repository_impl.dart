import 'package:cchelper/core/failures.dart';
import 'package:cchelper/core/network_exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/day_menu.dart';
import '../../domain/entities/meal.dart';
import '../../domain/repositories/meal_planner_repository.dart';
import '../datasources/meal_planner_local_datasource.dart';
import '../datasources/meal_planner_remote_datasource.dart';
import '../models/meal_model.dart';

@LazySingleton(as: MealPlannerRepository)
class MealPlannerRepositoryImpl implements MealPlannerRepository {
  final MealPlannerLocalDataSource localDataSource;
  final MealPlannerRemoteDataSource remoteDataSource;

  MealPlannerRepositoryImpl(this.localDataSource, this.remoteDataSource);

  DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Future<Either<Failure, Map<DateTime, DayMenu>>> getWeekMenu(DateTime weekStart) async {
    try {
      final monday = _normalizeDate(weekStart);
      final List<MealModel> meals = await localDataSource.getMealsForWeek(monday);

      // Group meals by normalized date for Mon - Fri
      final Map<DateTime, List<Meal>> grouped = {};
      for (int i = 0; i < 5; i++) {
        final date = monday.add(Duration(days: i));
        grouped[date] = [];
      }

      for (final meal in meals) {
        final mealDate = _normalizeDate(meal.date);
        if (grouped.containsKey(mealDate)) {
          grouped[mealDate]!.add(meal);
        } else {
          grouped[mealDate] = [meal];
        }
      }

      final Map<DateTime, DayMenu> result = {};
      for (final entry in grouped.entries) {
        result[entry.key] = DayMenu(
          date: entry.key,
          meals: entry.value,
        );
      }

      return Right(result);
    } on DioException {
      return Left(NetworkFailure());
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Meal>> updateMeal(Meal meal) async {
    try {
      final mealModel = MealModel.fromEntity(meal);
      await localDataSource.updateMeal(mealModel);
      try {
        await remoteDataSource.updateMeal(mealModel);
      } catch (_) {
        // Local update succeeded; remote sync failure is non-blocking
      }
      return Right(meal);
    } on DioException {
      return Left(NetworkFailure());
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteMeal(String mealId) async {
    try {
      await localDataSource.deleteMeal(mealId);
      try {
        await remoteDataSource.deleteMeal(mealId);
      } catch (_) {
        // Local delete succeeded; remote sync failure is non-blocking
      }
      return const Right(null);
    } on DioException {
      return Left(NetworkFailure());
    } catch (_) {
      return Left(UnknownFailure());
    }
  }
}
