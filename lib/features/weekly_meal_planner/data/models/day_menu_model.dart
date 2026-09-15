import '../../domain/entities/day_menu.dart';
import 'meal_model.dart';

class DayMenuModel extends DayMenu {
  const DayMenuModel({
    required super.date,
    required super.meals,
  });

  factory DayMenuModel.fromEntity(DayMenu menu) {
    return DayMenuModel(
      date: menu.date,
      meals: menu.meals.map((m) => MealModel.fromEntity(m)).toList(),
    );
  }

  factory DayMenuModel.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date'] as String);
    final rawMeals = json['meals'] as List<dynamic>? ?? [];
    return DayMenuModel(
      date: date,
      meals: rawMeals.map((e) => MealModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'meals': meals.map((m) => MealModel.fromEntity(m).toJson()).toList(),
    };
  }
}
