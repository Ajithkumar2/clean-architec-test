import 'package:clean_architecture_sample/feature/domain/post_entity.dart';
import 'package:clean_architecture_sample/feature/domain/post_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// State
abstract class PostState {}
class PostInitial extends PostState {}
class PostLoading extends PostState {}
class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded(this.posts);
}

// Bloc
@injectable
class PostBloc extends Bloc<dynamic, PostState> {
  final GetPostsUseCase getPostsUseCase;

  PostBloc(this.getPostsUseCase) : super(PostInitial()) {
    on<dynamic>((event, emit) async {
      emit(PostLoading());
      final posts = await getPostsUseCase.call();
      emit(PostLoaded(posts));
    });
  }
}