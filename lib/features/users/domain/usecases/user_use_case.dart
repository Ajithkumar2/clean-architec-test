
import 'package:cchelper/core/failures.dart';
import 'package:cchelper/features/users/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/user_entity.dart';


@lazySingleton
class UserUseCase {
  final UserRepository userRepository;
   UserUseCase(this.userRepository);

   Future<Either<Failure, List<User>>> call () async => userRepository.getUsers();
}