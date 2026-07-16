
import 'package:clean_architecture_sample/features/post/data/model/post_model.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton
class PostLocalDataSource {
  final Database db;
  PostLocalDataSource(this.db);

  Future<void> cachePosts(List<PostModel> posts) async {
    for (var post in posts) {
      await db.insert('posts', post.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<PostModel>> getLastPosts() async {
    final List<Map<String, dynamic>> maps = await db.query('posts');
    return maps.map((e) => PostModel.fromJson(e)).toList();
  }
}