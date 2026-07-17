
import 'package:clean_architecture_sample/core/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getUsers();
}