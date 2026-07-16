
import 'package:clean_architecture_sample/features/post/data/model/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> getPosts();
}