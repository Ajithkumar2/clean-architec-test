import 'package:clean_architecture_sample/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/user_entity.dart';
import '../model/user_model.dart';

@lazySingleton
class UserLocalDatasource {
  final Database db;
  UserLocalDatasource(this.db);

  Future<void> cacheUsers(List<UserModel> users) async {
    for (var u in users) {
      await db.insert('users', u.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<Either<Failure, List<User>>> getUsers() async {
    final maps = await db.query('users');
    return Right(maps.map((e) => UserModel.fromJson(e)).toList());
  }
}