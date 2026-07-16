import 'package:clean_architecture_sample/core/dio_client.dart';
import 'package:clean_architecture_sample/features/post/data/datasource/post_remote_datasource.dart';
import 'package:clean_architecture_sample/features/post/data/model/post_model.dart';
import 'package:clean_architecture_sample/locator.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../domain/enitites/post_entity.dart';
import '../../domain/repository/post_repository.dart';
import '../datasource/post_local_datasource.dart';

@LazySingleton(as: PostRepository)
class PostRepositoryImpl implements PostRepository {
  final PostRemoteDatasource remoteDatasource;

  PostRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      // Rule 2: Attempt API call
       return await remoteDatasource.getPosts();
    } catch (e) {
      // Rule 2: If network fails, load from SQL
      return await locator<PostLocalDataSource>().getLastPosts();
    }
  }
}