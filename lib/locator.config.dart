// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:clean_architecture_sample/core/dio_client.dart' as _i692;
import 'package:clean_architecture_sample/feature/data/lcoal_datasource.dart'
    as _i43;
import 'package:clean_architecture_sample/feature/data/post_repository_impl.dart'
    as _i669;
import 'package:clean_architecture_sample/feature/domain/post_repository.dart'
    as _i269;
import 'package:clean_architecture_sample/feature/domain/post_use_case.dart'
    as _i43;
import 'package:clean_architecture_sample/feature/presentation/post_bloc.dart'
    as _i460;
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
    gh.lazySingleton<_i692.DioClient>(() => _i692.DioClient());
    gh.lazySingleton<_i43.PostLocalDataSource>(
      () => _i43.PostLocalDataSource(gh<_i779.Database>()),
    );
    gh.lazySingleton<_i269.PostRepository>(
      () => _i669.PostRepositoryImpl(gh<_i43.PostLocalDataSource>()),
    );
    gh.lazySingleton<_i43.GetPostsUseCase>(
      () => _i43.GetPostsUseCase(gh<_i269.PostRepository>()),
    );
    gh.factory<_i460.PostBloc>(
      () => _i460.PostBloc(gh<_i43.GetPostsUseCase>()),
    );
    return this;
  }
}
