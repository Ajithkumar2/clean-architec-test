
import 'package:clean_architecture_sample/core/failures.dart';
import 'package:clean_architecture_sample/features/post/domain/enitites/post_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
}