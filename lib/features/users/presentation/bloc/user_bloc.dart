import 'package:clean_architecture_sample/features/users/domain/usecases/user_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user_entity.dart';

abstract class UserState extends Equatable{}

class UserInitial extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoadingState extends UserState {
  @override
  List<Object?> get props => [];
}

class UserErrorState extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoadedState extends UserState {
  final List<User> userList;
  UserLoadedState(this.userList);
  @override
  List<Object?> get props => [userList];
}


@injectable
class UserBloc extends Bloc<dynamic, UserState>{

  UserUseCase userUseCase;
  UserBloc(this.userUseCase) : super(UserInitial()) {
    on<dynamic>((event, emit) async {
      emit(UserLoadingState());
      final userList = await userUseCase.call();
      userList.fold((failure){
        emit(UserErrorState());
      }, (result) {
        emit(UserLoadedState(result));
      });
    });
  }
}