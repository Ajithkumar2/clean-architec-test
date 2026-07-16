import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

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

  Future<List<UserModel>> getUsers() async {
    final maps = await db.query('users');
    return maps.map((e) => UserModel.fromJson(e)).toList();
  }
}