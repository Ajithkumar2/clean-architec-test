import 'package:equatable/equatable.dart';
import 'meal_type.dart';

class Meal extends Equatable {
  final String id;
  final DateTime date;
  final MealType type;
  final String name;
  final String? referenceUrl;
  final String notes;

  const Meal({
    required this.id,
    required this.date,
    required this.type,
    required this.name,
    this.referenceUrl,
    required this.notes,
  });

  Meal copyWith({
    String? id,
    DateTime? date,
    MealType? type,
    String? name,
    String? referenceUrl,
    String? notes,
  }) {
    return Meal(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      name: name ?? this.name,
      referenceUrl: referenceUrl ?? this.referenceUrl,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, date, type, name, referenceUrl, notes];
}
