import 'package:clean_architecture_sample/core/failures.dart';
import 'package:clean_architecture_sample/features/post/domain/enitites/post_entity.dart';
import 'package:clean_architecture_sample/features/post/domain/repository/post_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetPostsUseCase {
  final PostRepository repository;
  GetPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call() async => await repository.getPosts();
}