import 'package:clean_architecture_sample/core/failures.dart';
import 'package:clean_architecture_sample/core/network_exceptions.dart';
import 'package:clean_architecture_sample/features/users/data/datasource/user_local_datasource.dart';
import 'package:clean_architecture_sample/features/users/data/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/dio_client.dart';
import '../../../../locator.dart';

abstract class UsersRemoteDatasource {
  Future<List<UserModel>> getUsers();
}

@LazySingleton(as: UsersRemoteDatasource)
class UsersRemoteDatasourceImpl extends UsersRemoteDatasource {

 final Dio dio;

 UsersRemoteDatasourceImpl(this.dio);

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final res = await dio.get('https://jsonplaceholder.typicode.com/users');
        final posts = (res.data as List).map((e) => UserModel.fromJson(e)).toList();
    return posts;
    } on DioException {
      throw NetworkException();
    } catch (exception, stackTrace) {
      throw ServerException();
    }
  }

}