import 'package:clean_architecture_sample/features/post/presentation/post_bloc.dart';
import 'package:clean_architecture_sample/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<PostBloc>()..add(Object()),
      child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PostLoaded) {
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, i) =>
                    ListTile(
                      title: Text(state.posts[i].title),
                      subtitle: Text(state.posts[i].body),
                    ),
              );
            }
            return const Text("Error loading page");
          }),
    );
  }
}
