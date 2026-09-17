import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../locator.dart';
import '../../domain/entities/meal_type.dart';
import '../bloc/week_menu_bloc.dart';
import '../bloc/week_menu_event.dart';
import '../bloc/week_menu_state.dart';
import '../widgets/meal_type_section.dart';
import '../widgets/week_date_selector.dart';

class WeeklyMealPlannerPage extends StatelessWidget {
  final bool showAppBar;

  const WeeklyMealPlannerPage({
    super.key,
    this.showAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: const Text('Weekly Meal Planner'),
              elevation: 0,
            )
          : null,
      body: const _WeeklyMealPlannerView(),
    );

    // If WeekMenuBloc is already provided above (e.g. from main.dart), use it directly
    try {
      context.read<WeekMenuBloc>();
      return scaffold;
    } catch (_) {
      return BlocProvider(
        create: (_) => locator<WeekMenuBloc>()..add(const LoadWeekMenuEvent()),
        child: scaffold,
      );
    }
  }
}

class _WeeklyMealPlannerView extends StatelessWidget {
  const _WeeklyMealPlannerView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<WeekMenuBloc, WeekMenuState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null && current.errorMessage != previous.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == WeekMenuStatus.loading && state.weeklyMenus.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading meal planner...'),
              ],
            ),
          );
        }

        if (state.status == WeekMenuStatus.error && state.weeklyMenus.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Failed to load meal plan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage ?? 'Something went wrong',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                    onPressed: () {
                      context.read<WeekMenuBloc>().add(
                            LoadWeekMenuEvent(weekStart: state.currentWeekStart),
                          );
                    },
                  ),
                ],
              ),
            ),
          );
        }

        final selectedDayMenu = state.selectedDayMenu;
        final selectedDate = state.selectedDate;

        return RefreshIndicator(
          onRefresh: () async {
            context.read<WeekMenuBloc>().add(
                  LoadWeekMenuEvent(weekStart: state.currentWeekStart),
                );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const WeekDateSelector(),
                const SizedBox(height: 8),
                MealTypeSection(
                  mealType: MealType.breakfast,
                  meals: selectedDayMenu?.breakfastMeals ?? const [],
                  date: selectedDate,
                ),
                MealTypeSection(
                  mealType: MealType.lunch,
                  meals: selectedDayMenu?.lunchMeals ?? const [],
                  date: selectedDate,
                ),
                MealTypeSection(
                  mealType: MealType.dinner,
                  meals: selectedDayMenu?.dinnerMeals ?? const [],
                  date: selectedDate,
                ),
                MealTypeSection(
                  mealType: MealType.snack,
                  meals: selectedDayMenu?.snackMeals ?? const [],
                  date: selectedDate,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
