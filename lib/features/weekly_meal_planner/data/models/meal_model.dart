import '../../domain/entities/meal.dart';
import '../../domain/entities/meal_type.dart';

class MealModel extends Meal {
  const MealModel({
    required super.id,
    required super.date,
    required super.type,
    required super.name,
    super.referenceUrl,
    required super.notes,
  });

  factory MealModel.fromEntity(Meal meal) {
    return MealModel(
      id: meal.id,
      date: meal.date,
      type: meal.type,
      name: meal.name,
      referenceUrl: meal.referenceUrl,
      notes: meal.notes,
    );
  }

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      type: MealType.fromString(json['type'] as String? ?? json['meal_type'] as String? ?? 'breakfast'),
      name: json['name'] as String? ?? '',
      referenceUrl: json['referenceUrl'] as String? ?? json['reference_url'] as String?,
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0],
      'type': type.name,
      'name': name,
      'referenceUrl': referenceUrl,
      'notes': notes,
    };
  }

  factory MealModel.fromDb(Map<String, dynamic> map) {
    return MealModel(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      type: MealType.fromString(map['meal_type'] as String),
      name: map['name'] as String? ?? '',
      referenceUrl: map['reference_url'] as String?,
      notes: map['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'date': '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'meal_type': type.name,
      'name': name,
      'reference_url': referenceUrl,
      'notes': notes,
    };
  }
}
