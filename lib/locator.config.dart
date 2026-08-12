// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:clean_architecture_sample/core/di_module.dart' as _i733;
import 'package:clean_architecture_sample/core/dio_client.dart' as _i692;
import 'package:clean_architecture_sample/features/post/data/datasource/post_local_datasource.dart'
    as _i601;
import 'package:clean_architecture_sample/features/post/data/datasource/post_remote_datasource.dart'
    as _i383;
import 'package:clean_architecture_sample/features/post/data/repositories/post_repository_impl.dart'
    as _i45;
import 'package:clean_architecture_sample/features/post/domain/repository/post_repository.dart'
    as _i947;
import 'package:clean_architecture_sample/features/post/domain/usecase/post_use_case.dart'
    as _i826;
import 'package:clean_architecture_sample/features/post/presentation/post_bloc.dart'
    as _i250;
import 'package:clean_architecture_sample/features/users/data/datasource/user_local_datasource.dart'
    as _i327;
import 'package:clean_architecture_sample/features/users/data/datasource/users_remote_datasource_impl.dart'
    as _i914;
import 'package:clean_architecture_sample/features/users/data/repositories/user_repo_impl.dart'
    as _i789;
import 'package:clean_architecture_sample/features/users/domain/repository/user_repository.dart'
    as _i653;
import 'package:clean_architecture_sample/features/users/domain/usecases/user_use_case.dart'
    as _i381;
import 'package:clean_architecture_sample/features/users/presentation/bloc/user_bloc.dart'
    as _i494;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sqflite/sqflite.dart' as _i779;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i692.DioClient>(() => _i692.DioClient());
    gh.lazySingleton<_i601.PostLocalDataSource>(
      () => _i601.PostLocalDataSource(gh<_i779.Database>()),
    );
    gh.lazySingleton<_i327.UserLocalDatasource>(
      () => _i327.UserLocalDatasource(gh<_i779.Database>()),
    );
    gh.lazySingleton<_i383.PostRemoteDatasource>(
      () => _i383.PostRemoteDatasourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i914.UsersRemoteDatasource>(
      () => _i914.UsersRemoteDatasourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i947.PostRepository>(
      () => _i45.PostRepositoryImpl(gh<_i383.PostRemoteDatasource>()),
    );
    gh.lazySingleton<_i826.GetPostsUseCase>(
      () => _i826.GetPostsUseCase(gh<_i947.PostRepository>()),
    );
    gh.lazySingleton<_i653.UserRepository>(
      () => _i789.UserRepoImpl(gh<_i914.UsersRemoteDatasource>()),
    );
    gh.factory<_i250.PostBloc>(
      () => _i250.PostBloc(gh<_i826.GetPostsUseCase>()),
    );
    gh.lazySingleton<_i381.UserUseCase>(
      () => _i381.UserUseCase(gh<_i653.UserRepository>()),
    );
    gh.factory<_i494.UserBloc>(() => _i494.UserBloc(gh<_i381.UserUseCase>()));
    return this;
  }
}

class _$RegisterModule extends _i733.RegisterModule {}
