
import 'package:cchelper/core/failures.dart';
import 'package:cchelper/features/post/domain/enitites/post_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
}