
import 'package:clean_architecture_sample/features/users/domain/entities/user_entity.dart';
import 'package:clean_architecture_sample/features/users/domain/usecases/user_use_case.dart';
import 'package:clean_architecture_sample/features/users/presentation/bloc/user_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../domain/usecase/usecase_test.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  late MockUserRepository repository;

  setUp(() {
    repository = MockUserRepository();
  });

  blocTest<UserBloc, UserState>(
    'emits loading then loaded',
    build: () {
      when(repository.getUsers()).thenAnswer(
          (_) async => Right([User(id: 1, name: "Ajith", email: "ajith@gmail.com")]));
      return UserBloc(UserUseCase(repository));
    },
    act: (bloc) {
      bloc.add(UserInitial());
    },
    expect: () => <Matcher>[
     isA<UserLoadingState>(), isA<UserLoadedState>()
    ],
  );
}