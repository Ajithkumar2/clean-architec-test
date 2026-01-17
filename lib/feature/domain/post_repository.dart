import 'package:clean_architecture_sample/feature/domain/post_entity.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();
}