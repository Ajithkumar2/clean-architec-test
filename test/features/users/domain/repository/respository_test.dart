import 'package:clean_architecture_sample/core/failures.dart';
import 'package:clean_architecture_sample/features/users/data/datasource/users_remote_datasource_impl.dart';
import 'package:clean_architecture_sample/features/users/data/model/user_model.dart';
import 'package:clean_architecture_sample/features/users/data/repositories/user_repo_impl.dart';
import 'package:clean_architecture_sample/features/users/domain/repository/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'respository_test.mocks.dart';

@GenerateMocks([UsersRemoteDatasource])

void main() {
  late MockUsersRemoteDatasource datasource;
  late UserRepoImpl userRepoImpl;

  setUp(() {
    datasource = MockUsersRemoteDatasource();
    userRepoImpl = UserRepoImpl(datasource);
  });

  group("Repository test", () {
    test('returns Right when datasource succeeds', () async {
      const UserModel user = UserModel(id: 1, name: "ajith", email:"ajith@gmail.com");
      final userModel = <UserModel>[user];
      when(datasource.getUsers())
          .thenAnswer((_) async => userModel);
      final result = await userRepoImpl.getUsers();
      expect(result.isRight(), true);
    });
  });

  test("Returns Network failure", () async {
    when(datasource.getUsers()).thenThrow(NetworkFailure());
    final result = await userRepoImpl.getUsers();
    expect(result.isLeft(), true);
  });
}