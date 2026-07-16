
import 'package:clean_architecture_sample/features/users/domain/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/user_model.dart';

@lazySingleton
class UserUseCase {
  final UserRepository userRepository;
   UserUseCase(this.userRepository);

   Future<List<UserModel>> call () async => userRepository.getUsers();
}