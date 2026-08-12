import 'package:clean_architecture_sample/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../users/domain/entities/user_entity.dart';
import '../../users/domain/usecases/user_use_case.dart';
import '../domain/enitites/post_entity.dart';
import '../domain/usecase/post_use_case.dart';

// State
abstract class PostState {}
class PostInitial extends PostState {}
class PostLoading extends PostState {}
class PostErrorState extends PostState {}
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
      posts.fold((failure) {
        emit(PostErrorState());
      }, (postList) {
        emit(PostLoaded(postList));
      });
    });
  }
}