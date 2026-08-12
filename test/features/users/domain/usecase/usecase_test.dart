import 'package:clean_architecture_sample/features/users/domain/entities/user_entity.dart';
import 'package:clean_architecture_sample/features/users/domain/repository/user_repository.dart';
import 'package:clean_architecture_sample/features/users/domain/usecases/user_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'usecase_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository userRepository;
  late UserUseCase userUseCase;

  setUp(() {
    userRepository = MockUserRepository();
    userUseCase = UserUseCase(userRepository);
  });

  group("Use case test", () {
    test("calls repository at once", () async {
      final user = [User(id: 1, name: "Ajith", email: "ajith@gmail.com")];
      when(userRepository.getUsers()).thenAnswer((_) async {
        return Right(user);
      });

      final result = await userUseCase();
      expect(result, Right(user));
      verify(userRepository.getUsers()).called(1);
    });
  });
}
