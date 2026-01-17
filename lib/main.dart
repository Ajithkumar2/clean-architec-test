import 'package:clean_architecture_sample/core/dio_client.dart';
import 'package:clean_architecture_sample/feature/presentation/post_bloc.dart';
import 'package:clean_architecture_sample/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  locator<DioClient>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => locator<PostBloc>()..add(Object()), // Trigger fetch
        child: Scaffold(
          appBar: AppBar(title: const Text('Clean Architecture Posts')),
          body: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostLoading) return const Center(child: CircularProgressIndicator());
              if (state is PostLoaded) {
                return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, i) => ListTile(
                    title: Text(state.posts[i].title),
                    subtitle: Text(state.posts[i].body),
                  ),
                );
              }
              return const Center(child: Text("Pull to refresh"));
            },
          ),
        ),
      ),
    );
  }
}