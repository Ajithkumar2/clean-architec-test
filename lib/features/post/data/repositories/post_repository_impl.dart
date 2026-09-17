import 'package:cchelper/core/dio_client.dart';
import 'package:cchelper/core/failures.dart';
import 'package:cchelper/core/network_exceptions.dart';
import 'package:cchelper/features/post/data/datasource/post_remote_datasource.dart';
import 'package:cchelper/features/post/data/model/post_model.dart';
import 'package:cchelper/locator.dart';
import 'package:dartz/dartz.dart';
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
  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      // Rule 2: Attempt API call
      final result = await remoteDatasource.getPosts();
       return Right(result);
    } on DioException {
      return Left(NetworkFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
    catch (e) {
      return Left(UnknownFailure());
      // return await locator<PostLocalDataSource>().getLastPosts();
    }
  }
}