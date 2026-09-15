import 'package:bloc_test/bloc_test.dart';
import 'package:cchelper/core/failures.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/entities/day_menu.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/entities/meal.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/entities/meal_type.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/repositories/meal_planner_repository.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/usecases/delete_meal_usecase.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/usecases/get_week_menu_usecase.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/usecases/update_meal_usecase.dart';
import 'package:cchelper/features/weekly_meal_planner/presentation/bloc/week_menu_bloc.dart';
import 'package:cchelper/features/weekly_meal_planner/presentation/bloc/week_menu_event.dart';
import 'package:cchelper/features/weekly_meal_planner/presentation/bloc/week_menu_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRepo implements MealPlannerRepository {
  Map<DateTime, DayMenu> data = {};
  bool fail = false;

  @override
  Future<Either<Failure, Map<DateTime, DayMenu>>> getWeekMenu(DateTime weekStart) async {
    if (fail) return Left(ServerFailure());
    return Right(data);
  }

  @override
  Future<Either<Failure, Meal>> updateMeal(Meal meal) async {
    if (fail) return Left(ServerFailure());
    return Right(meal);
  }

  @override
  Future<Either<Failure, void>> deleteMeal(String mealId) async {
    if (fail) return Left(ServerFailure());
    return const Right(null);
  }
}

void main() {
  late FakeRepo fakeRepo;
  late GetWeekMenuUseCase getWeekMenuUseCase;
  late UpdateMealUseCase updateMealUseCase;
  late DeleteMealUseCase deleteMealUseCase;

  setUp(() {
    fakeRepo = FakeRepo();
    getWeekMenuUseCase = GetWeekMenuUseCase(fakeRepo);
    updateMealUseCase = UpdateMealUseCase(fakeRepo);
    deleteMealUseCase = DeleteMealUseCase(fakeRepo);
  });

  WeekMenuBloc buildBloc() {
    return WeekMenuBloc(
      getWeekMenuUseCase: getWeekMenuUseCase,
      updateMealUseCase: updateMealUseCase,
      deleteMealUseCase: deleteMealUseCase,
    );
  }

  final monday = DateTime(2026, 9, 14);
  final tuesday = DateTime(2026, 9, 15);
  final testMeal = Meal(
    id: '2026-09-14_breakfast',
    date: monday,
    type: MealType.breakfast,
    name: 'Avocado Toast',
    referenceUrl: 'https://example.com',
    notes: 'Delicious',
  );

  group('WeekMenuBloc', () {
    test('initial state has 5 weekDates (Mon-Fri) and initial status', () {
      final bloc = buildBloc();
      expect(bloc.state.status, WeekMenuStatus.initial);
      expect(bloc.state.weekDates.length, 5);
      expect(bloc.state.currentWeekStart.weekday, DateTime.monday);
      expect(bloc.state.editingMealId, isNull);
    });

    blocTest<WeekMenuBloc, WeekMenuState>(
      'emits [loading, loaded] when LoadWeekMenuEvent succeeds',
      build: () {
        fakeRepo.data = {
          monday: DayMenu(date: monday, meals: [testMeal]),
        };
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadWeekMenuEvent(weekStart: monday)),
      expect: () => [
        predicate<WeekMenuState>((s) => s.status == WeekMenuStatus.loading),
        predicate<WeekMenuState>(
          (s) =>
              s.status == WeekMenuStatus.loaded &&
              s.weeklyMenus.containsKey(monday) &&
              s.weeklyMenus[monday]!.meals.first == testMeal,
        ),
      ],
    );

    blocTest<WeekMenuBloc, WeekMenuState>(
      'emits [loading, error] when LoadWeekMenuEvent fails',
      build: () {
        fakeRepo.fail = true;
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadWeekMenuEvent(weekStart: monday)),
      expect: () => [
        predicate<WeekMenuState>((s) => s.status == WeekMenuStatus.loading),
        predicate<WeekMenuState>((s) => s.status == WeekMenuStatus.error),
      ],
    );

    blocTest<WeekMenuBloc, WeekMenuState>(
      'SelectDateEvent updates selectedDate without emitting loading if cached',
      build: () => buildBloc(),
      seed: () => WeekMenuState(
        status: WeekMenuStatus.loaded,
        currentWeekStart: monday,
        weekDates: [monday, tuesday],
        selectedDate: monday,
        weeklyMenus: {
          tuesday: DayMenu(date: tuesday, meals: const []),
        },
      ),
      act: (bloc) => bloc.add(SelectDateEvent(tuesday)),
      expect: () => [
        predicate<WeekMenuState>(
          (s) => s.selectedDate == tuesday && s.status == WeekMenuStatus.loaded,
        ),
      ],
    );

    blocTest<WeekMenuBloc, WeekMenuState>(
      'WeekChangedEvent recalculates Mon-Fri range and updates currentWeekStart',
      build: () {
        fakeRepo.data = {};
        return buildBloc();
      },
      act: (bloc) => bloc.add(WeekChangedEvent(DateTime(2026, 9, 23))), // Wednesday
      verify: (bloc) {
        // Monday for Sept 23, 2026 is Sept 21, 2026
        expect(bloc.state.currentWeekStart, DateTime(2026, 9, 21));
        expect(bloc.state.selectedDate, DateTime(2026, 9, 23));
        expect(bloc.state.weekDates.length, 5);
      },
    );

    blocTest<WeekMenuBloc, WeekMenuState>(
      'AddMealEvent appends meal to in-memory week menu and sets editingMealId',
      build: () => buildBloc(),
      seed: () => WeekMenuState(
        status: WeekMenuStatus.loaded,
        currentWeekStart: monday,
        weekDates: [monday],
        selectedDate: monday,
        weeklyMenus: {
          monday: DayMenu(date: monday, meals: const []),
        },
      ),
      act: (bloc) => bloc.add(AddMealEvent(testMeal)),
      expect: () => [
        predicate<WeekMenuState>((s) {
          final dayMenu = s.weeklyMenus[monday];
          return dayMenu != null &&
              dayMenu.meals.length == 1 &&
              dayMenu.meals.first == testMeal &&
              s.editingMealId == testMeal.id;
        }),
      ],
    );

    blocTest<WeekMenuBloc, WeekMenuState>(
      'UpdateMealEvent updates meal in weeklyMenus state and clears editingMealId',
      build: () => buildBloc(),
      seed: () => WeekMenuState(
        status: WeekMenuStatus.loaded,
        currentWeekStart: monday,
        weekDates: [monday],
        selectedDate: monday,
        editingMealId: testMeal.id,
        weeklyMenus: {
          monday: DayMenu(date: monday, meals: [testMeal]),
        },
      ),
      act: (bloc) {
        final updated = testMeal.copyWith(name: 'Updated Sourdough Toast');
        bloc.add(UpdateMealEvent(updated));
      },
      expect: () => [
        predicate<WeekMenuState>((s) {
          final meal = s.weeklyMenus[monday]?.meals.first;
          return meal?.name == 'Updated Sourdough Toast' && s.editingMealId == null;
        }),
      ],
    );

    blocTest<WeekMenuBloc, WeekMenuState>(
      'DeleteMealEvent removes meal from weeklyMenus state and clears editingMealId',
      build: () => buildBloc(),
      seed: () => WeekMenuState(
        status: WeekMenuStatus.loaded,
        currentWeekStart: monday,
        weekDates: [monday],
        selectedDate: monday,
        editingMealId: testMeal.id,
        weeklyMenus: {
          monday: DayMenu(date: monday, meals: [testMeal]),
        },
      ),
      act: (bloc) => bloc.add(DeleteMealEvent(testMeal.id, monday, testMeal.type)),
      expect: () => [
        predicate<WeekMenuState>((s) {
          final dayMenu = s.weeklyMenus[monday];
          return dayMenu != null && dayMenu.meals.isEmpty && s.editingMealId == null;
        }),
      ],
    );

    blocTest<WeekMenuBloc, WeekMenuState>(
      'ToggleMealEditMode toggles editingMealId between meal ID and null',
      build: () => buildBloc(),
      act: (bloc) {
        bloc.add(ToggleMealEditMode(testMeal.id));
      },
      expect: () => [
        predicate<WeekMenuState>((s) => s.editingMealId == testMeal.id),
      ],
    );
  });
}
