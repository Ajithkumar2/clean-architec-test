import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/meal.dart';
import '../../domain/entities/meal_type.dart';
import '../bloc/week_menu_bloc.dart';
import '../bloc/week_menu_event.dart';
import 'meal_card.dart';

class MealTypeSection extends StatelessWidget {
  final MealType mealType;
  final List<Meal> meals;
  final DateTime date;

  const MealTypeSection({
    super.key,
    required this.mealType,
    required this.meals,
    required this.date,
  });

  IconData get _icon {
    switch (mealType) {
      case MealType.breakfast:
        return Icons.wb_sunny_rounded;
      case MealType.lunch:
        return Icons.lunch_dining_rounded;
      case MealType.dinner:
        return Icons.dinner_dining_rounded;
      case MealType.snack:
        return Icons.cookie_outlined;
    }
  }

  Color _accentColor(ThemeData theme) {
    switch (mealType) {
      case MealType.breakfast:
        return Colors.amber.shade700;
      case MealType.lunch:
        return Colors.teal.shade700;
      case MealType.dinner:
        return Colors.indigo.shade700;
      case MealType.snack:
        return Colors.orange.shade700;
    }
  }

  void _addNewMeal(BuildContext context) {
    final dateStr =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final isSnack = mealType == MealType.snack;
    final newMeal = Meal(
      id: '${dateStr}_${mealType.name}_${DateTime.now().millisecondsSinceEpoch}',
      date: date,
      type: mealType,
      name: 'New ${mealType.displayName}',
      referenceUrl: isSnack ? null : '',
      notes: '',
    );
    context.read<WeekMenuBloc>().add(AddMealEvent(newMeal));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = _accentColor(theme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_icon, color: accent, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                mealType.displayName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${meals.length}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => _addNewMeal(context),
              ),
            ],
          ),
        ),
        // Meals List
        if (meals.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Card(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.4),
                  style: BorderStyle.solid,
                ),
              ),
              child: InkWell(
                onTap: () => _addNewMeal(context),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          _icon,
                          size: 26,
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'No ${mealType.displayName.toLowerCase()} planned',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FilledButton.tonalIcon(
                          icon: const Icon(Icons.add, size: 16),
                          label: Text('Add ${mealType.displayName}'),
                          style: FilledButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                          onPressed: () => _addNewMeal(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: meals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final meal = meals[index];
              return MealCard(
                key: ValueKey(meal.id),
                meal: meal,
              );
            },
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
