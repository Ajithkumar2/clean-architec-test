import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import '../models/meal_model.dart';

@lazySingleton
class MealPlannerLocalDataSource {
  final Database db;

  MealPlannerLocalDataSource(this.db);

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  DateTime _normalizeDate(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  Future<List<MealModel>> getMealsForWeek(DateTime weekStart) async {
    final monday = _normalizeDate(weekStart);
    final friday = monday.add(const Duration(days: 4));
    final startDateStr = _formatDate(monday);
    final endDateStr = _formatDate(friday);

    final List<Map<String, dynamic>> results = await db.query(
      'meals',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDateStr, endDateStr],
      orderBy: 'date ASC, meal_type ASC',
    );

    return results.map((map) => MealModel.fromDb(map)).toList();
  }

  Future<MealModel> updateMeal(MealModel meal) async {
    await db.insert(
      'meals',
      meal.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return meal;
  }

  Future<void> deleteMeal(String mealId) async {
    await db.delete(
      'meals',
      where: 'id = ?',
      whereArgs: [mealId],
    );
  }
}
