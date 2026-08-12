import 'package:clean_architecture_sample/features/post/presentation/post_bloc.dart';
import 'package:clean_architecture_sample/features/users/presentation/bloc/user_bloc.dart';
import 'package:clean_architecture_sample/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create:(context)=> locator<UserBloc>()..add(Object()),
        child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if(state is UserLoadingState) {
                return Center(child: CircularProgressIndicator());
              }
              else if(state is UserLoadedState) {
                return  ListView.builder(
                  itemCount: state.userList.length,
                  itemBuilder: (context, i) => ListTile(
                    title: Text(state.userList[i].name),
                    subtitle: Text(state.userList[i].email),
                  ),
                );
              }
              return Text("Error in loading user");
            }),);
  }
}
