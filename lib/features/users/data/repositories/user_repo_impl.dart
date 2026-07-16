import 'package:clean_architecture_sample/features/users/data/datasource/user_local_datasource.dart';
import 'package:clean_architecture_sample/features/users/data/datasource/users_remote_datasource_impl.dart';
import 'package:clean_architecture_sample/features/users/data/model/user_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../locator.dart';
import '../../domain/repository/user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepoImpl extends UserRepository {
  final UsersRemoteDatasource usersRemoteDatasource;

  UserRepoImpl(this.usersRemoteDatasource);

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final users = await usersRemoteDatasource.getUsers();
      await locator<UserLocalDatasource>().cacheUsers(users);
      return users;
    } catch (e) {
      return await locator<UserLocalDatasource>().getUsers();
    }
  }
}