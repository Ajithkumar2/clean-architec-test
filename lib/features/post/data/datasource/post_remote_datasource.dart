import 'package:clean_architecture_sample/features/post/data/datasource/post_local_datasource.dart';
import 'package:clean_architecture_sample/features/post/domain/enitites/post_entity.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/dio_client.dart';
import '../../../../locator.dart';
import '../model/post_model.dart';

abstract class PostRemoteDatasource {
  Future<List<PostModel>> getPosts();
}

@LazySingleton(as: PostRemoteDatasource)
class PostRemoteDatasourceImpl extends PostRemoteDatasource {

  final Dio dio;
  PostRemoteDatasourceImpl(this.dio);

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      // Rule 2: Attempt API call
      final response = await locator<DioClient>().dio.get('https://jsonplaceholder.typicode.com/posts');
      final List<PostModel> posts = (response.data as List)
          .map((json) => PostModel.fromJson(json))
          .toList();

      // Cache data for offline use
      await locator<PostLocalDataSource>().cachePosts(posts);
    return posts;
    } catch (e) {
    // Rule 2: If network fails, load from SQL
    return await locator<PostLocalDataSource>().getLastPosts();
    }
  }

}