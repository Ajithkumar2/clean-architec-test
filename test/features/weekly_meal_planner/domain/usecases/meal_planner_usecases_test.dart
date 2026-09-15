import 'package:cchelper/core/failures.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/entities/day_menu.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/entities/meal.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/entities/meal_type.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/repositories/meal_planner_repository.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/usecases/delete_meal_usecase.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/usecases/get_week_menu_usecase.dart';
import 'package:cchelper/features/weekly_meal_planner/domain/usecases/update_meal_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeMealPlannerRepository implements MealPlannerRepository {
  Map<DateTime, DayMenu> fakeWeekMenu = {};
  Meal? lastUpdatedMeal;
  String? lastDeletedMealId;
  bool shouldFail = false;

  @override
  Future<Either<Failure, Map<DateTime, DayMenu>>> getWeekMenu(DateTime weekStart) async {
    if (shouldFail) return Left(ServerFailure());
    return Right(fakeWeekMenu);
  }

  @override
  Future<Either<Failure, Meal>> updateMeal(Meal meal) async {
    if (shouldFail) return Left(ServerFailure());
    lastUpdatedMeal = meal;
    return Right(meal);
  }

  @override
  Future<Either<Failure, void>> deleteMeal(String mealId) async {
    if (shouldFail) return Left(ServerFailure());
    lastDeletedMealId = mealId;
    return const Right(null);
  }
}

void main() {
  late FakeMealPlannerRepository fakeRepo;
  late GetWeekMenuUseCase getWeekMenuUseCase;
  late UpdateMealUseCase updateMealUseCase;
  late DeleteMealUseCase deleteMealUseCase;

  setUp(() {
    fakeRepo = FakeMealPlannerRepository();
    getWeekMenuUseCase = GetWeekMenuUseCase(fakeRepo);
    updateMealUseCase = UpdateMealUseCase(fakeRepo);
    deleteMealUseCase = DeleteMealUseCase(fakeRepo);
  });

  final testDate = DateTime(2026, 9, 14);
  final testMeal = Meal(
    id: '2026-09-14_breakfast',
    date: testDate,
    type: MealType.breakfast,
    name: 'Avocado Toast',
    referenceUrl: 'https://example.com',
    notes: 'Extra chili flakes',
  );

  group('GetWeekMenuUseCase', () {
    test('should return week menu from repository on success', () async {
      final menu = {
        testDate: DayMenu(date: testDate, meals: [testMeal]),
      };
      fakeRepo.fakeWeekMenu = menu;

      final result = await getWeekMenuUseCase(testDate);

      expect(result, Right(menu));
    });

    test('should return ServerFailure when repository fails', () async {
      fakeRepo.shouldFail = true;

      final result = await getWeekMenuUseCase(testDate);

      expect(result, Left(ServerFailure()));
    });
  });

  group('UpdateMealUseCase', () {
    test('should update meal and return updated entity on success', () async {
      final updatedMeal = testMeal.copyWith(name: 'Updated Toast');

      final result = await updateMealUseCase(updatedMeal);

      expect(result, Right(updatedMeal));
      expect(fakeRepo.lastUpdatedMeal, updatedMeal);
    });

    test('should return Failure when repository update fails', () async {
      fakeRepo.shouldFail = true;

      final result = await updateMealUseCase(testMeal);

      expect(result, Left(ServerFailure()));
    });
  });

  group('DeleteMealUseCase', () {
    test('should delete meal on success', () async {
      final result = await deleteMealUseCase('2026-09-14_breakfast');

      expect(result, const Right(null));
      expect(fakeRepo.lastDeletedMealId, '2026-09-14_breakfast');
    });

    test('should return Failure when repository delete fails', () async {
      fakeRepo.shouldFail = true;

      final result = await deleteMealUseCase('2026-09-14_breakfast');

      expect(result, Left(ServerFailure()));
    });
  });
}
