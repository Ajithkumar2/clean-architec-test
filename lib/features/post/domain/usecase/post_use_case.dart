import 'package:clean_architecture_sample/features/post/data/model/post_model.dart';
import 'package:clean_architecture_sample/features/post/domain/enitites/post_entity.dart';
import 'package:clean_architecture_sample/features/post/domain/repository/post_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetPostsUseCase {
  final PostRepository repository;
  GetPostsUseCase(this.repository);

  Future<List<PostModel>> call() async => await repository.getPosts();
}