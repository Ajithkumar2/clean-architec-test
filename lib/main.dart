import 'package:clean_architecture_sample/core/dio_client.dart';
import 'package:clean_architecture_sample/features/post/presentation/post_widget.dart';
import 'package:clean_architecture_sample/features/users/presentation/widget/user_widget.dart';
import 'package:clean_architecture_sample/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/post/presentation/post_bloc.dart';

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
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(title: const Text('Clean Architecture Posts')),
            body: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoading) return const Center(child: CircularProgressIndicator());
                if (state is PostLoaded) {
                  return TabBarView(
                    children: [
                      PostWidget(),
                      UserWidget()
                    ],
                  );
                }
                return const Center(child: Text("Pull to refresh"));
              },
            ),
          ),
        ),
      ),
    );
  }
}