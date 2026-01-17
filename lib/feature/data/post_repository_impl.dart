import 'package:clean_architecture_sample/core/dio_client.dart';
import 'package:clean_architecture_sample/feature/data/lcoal_datasource.dart';
import 'package:clean_architecture_sample/feature/data/post_model.dart';
import 'package:clean_architecture_sample/feature/domain/post_entity.dart';
import 'package:clean_architecture_sample/feature/domain/post_repository.dart';
import 'package:clean_architecture_sample/locator.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PostRepository)
class PostRepositoryImpl implements PostRepository {
  final PostLocalDataSource localDataSource;
  final Dio dio = Dio();

  PostRepositoryImpl(this.localDataSource);

  @override
  Future<List<Post>> getPosts() async {
    try {
      // Rule 2: Attempt API call
      final response = await locator<DioClient>().dio.get('https://jsonplaceholder.typicode.com/posts');
      final List<PostModel> posts = (response.data as List)
          .map((json) => PostModel.fromJson(json))
          .toList();
      
      // Cache data for offline use
      await localDataSource.cachePosts(posts);
      return posts;
    } catch (e) {
      // Rule 2: If network fails, load from SQL
      return await localDataSource.getLastPosts();
    }
  }
}