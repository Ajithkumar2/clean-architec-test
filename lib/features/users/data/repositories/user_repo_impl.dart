import 'package:cchelper/core/failures.dart';
import 'package:cchelper/features/users/data/datasource/user_local_datasource.dart';
import 'package:cchelper/features/users/data/datasource/users_remote_datasource_impl.dart';
import 'package:cchelper/features/users/data/model/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../locator.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepoImpl extends UserRepository {
  final UsersRemoteDatasource usersRemoteDatasource;

  UserRepoImpl(this.usersRemoteDatasource);

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final users = await usersRemoteDatasource.getUsers();
      await locator<UserLocalDatasource>().cacheUsers(users);
      return Right(users);
    } on NetworkFailure {
       // await locator<UserLocalDatasource>().getUsers();
      return Left(NetworkFailure());
    } on ServerFailure {
      return Left(ServerFailure());
    } catch (_) {
      return Left(UnknownFailure());
    }
  }
}