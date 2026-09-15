import 'package:cchelper/core/failures.dart';
import 'package:cchelper/features/post/domain/enitites/post_entity.dart';
import 'package:cchelper/features/post/domain/repository/post_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetPostsUseCase {
  final PostRepository repository;
  GetPostsUseCase(this.repository);

  Future<Either<Failure, List<Post>>> call() async => await repository.getPosts();
}