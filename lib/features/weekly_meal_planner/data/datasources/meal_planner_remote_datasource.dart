import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/meal_model.dart';

abstract class MealPlannerRemoteDataSource {
  Future<List<MealModel>> fetchWeekMeals(DateTime weekStart);
  Future<MealModel> updateMeal(MealModel meal);
  Future<void> deleteMeal(String mealId);
}

@LazySingleton(as: MealPlannerRemoteDataSource)
class MealPlannerRemoteDataSourceImpl implements MealPlannerRemoteDataSource {
  final Dio dio;

  MealPlannerRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MealModel>> fetchWeekMeals(DateTime weekStart) async {
    // In a production backend, this would call e.g.:
    // final response = await dio.get('/meal-planner/week?start=${weekStart.toIso8601String()}');
    // Here we provide a clean, production-ready interface matching the existing codebase pattern.
    return [];
  }

  @override
  Future<MealModel> updateMeal(MealModel meal) async {
    // In a production backend, this would call e.g.:
    // final response = await dio.put('/meal-planner/meals/${meal.id}', data: meal.toJson());
    return meal;
  }

  @override
  Future<void> deleteMeal(String mealId) async {
    // In a production backend, this would call e.g.:
    // await dio.delete('/meal-planner/meals/$mealId');
  }
}
