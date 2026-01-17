import 'package:clean_architecture_sample/feature/domain/post_entity.dart';
import 'package:clean_architecture_sample/feature/domain/post_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetPostsUseCase {
  final PostRepository repository;
  GetPostsUseCase(this.repository);

  Future<List<Post>> call() async => await repository.getPosts();
}