// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cchelper/core/di_module.dart' as _i477;
import 'package:cchelper/core/dio_client.dart' as _i823;
import 'package:cchelper/features/post/data/datasource/post_local_datasource.dart'
    as _i108;
import 'package:cchelper/features/post/data/datasource/post_remote_datasource.dart'
    as _i514;
import 'package:cchelper/features/post/data/repositories/post_repository_impl.dart'
    as _i957;
import 'package:cchelper/features/post/domain/repository/post_repository.dart'
    as _i136;
import 'package:cchelper/features/post/domain/usecase/post_use_case.dart'
    as _i479;
import 'package:cchelper/features/post/presentation/post_bloc.dart' as _i1021;
import 'package:cchelper/features/users/data/datasource/user_local_datasource.dart'
    as _i726;
import 'package:cchelper/features/users/data/datasource/users_remote_datasource_impl.dart'
    as _i951;
import 'package:cchelper/features/users/data/repositories/user_repo_impl.dart'
    as _i193;
import 'package:cchelper/features/users/domain/repository/user_repository.dart'
    as _i331;
import 'package:cchelper/features/users/domain/usecases/user_use_case.dart'
    as _i791;
import 'package:cchelper/features/users/presentation/bloc/user_bloc.dart'
    as _i1002;
import 'package:cchelper/features/weekly_meal_planner/data/datasources/meal_planner_local_datasource.dart'
    as _i663;
import 'package:cchelper/features/weekly_meal_planner/data/datasources/meal_planner_remote_datasource.dart'
    as _i72;
import 'package:cchelper/features/weekly_meal_planner/data/repositories/meal_planner_repository_impl.dart'
    as _i419;
import 'package:cchelper/features/weekly_meal_planner/domain/repositories/meal_planner_repository.dart'
    as _i658;
import 'package:cchelper/features/weekly_meal_planner/domain/usecases/delete_meal_usecase.dart'
    as _i740;
import 'package:cchelper/features/weekly_meal_planner/domain/usecases/get_week_menu_usecase.dart'
    as _i389;
import 'package:cchelper/features/weekly_meal_planner/domain/usecases/update_meal_usecase.dart'
    as _i619;
import 'package:cchelper/features/weekly_meal_planner/presentation/bloc/week_menu_bloc.dart'
    as _i138;
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
    gh.lazySingleton<_i823.DioClient>(() => _i823.DioClient());
    gh.lazySingleton<_i72.MealPlannerRemoteDataSource>(
      () => _i72.MealPlannerRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i514.PostRemoteDatasource>(
      () => _i514.PostRemoteDatasourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i951.UsersRemoteDatasource>(
      () => _i951.UsersRemoteDatasourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i331.UserRepository>(
      () => _i193.UserRepoImpl(gh<_i951.UsersRemoteDatasource>()),
    );
    gh.lazySingleton<_i108.PostLocalDataSource>(
      () => _i108.PostLocalDataSource(gh<_i779.Database>()),
    );
    gh.lazySingleton<_i726.UserLocalDatasource>(
      () => _i726.UserLocalDatasource(gh<_i779.Database>()),
    );
    gh.lazySingleton<_i663.MealPlannerLocalDataSource>(
      () => _i663.MealPlannerLocalDataSource(gh<_i779.Database>()),
    );
    gh.lazySingleton<_i136.PostRepository>(
      () => _i957.PostRepositoryImpl(gh<_i514.PostRemoteDatasource>()),
    );
    gh.lazySingleton<_i658.MealPlannerRepository>(
      () => _i419.MealPlannerRepositoryImpl(
        gh<_i663.MealPlannerLocalDataSource>(),
        gh<_i72.MealPlannerRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i791.UserUseCase>(
      () => _i791.UserUseCase(gh<_i331.UserRepository>()),
    );
    gh.lazySingleton<_i740.DeleteMealUseCase>(
      () => _i740.DeleteMealUseCase(gh<_i658.MealPlannerRepository>()),
    );
    gh.lazySingleton<_i389.GetWeekMenuUseCase>(
      () => _i389.GetWeekMenuUseCase(gh<_i658.MealPlannerRepository>()),
    );
    gh.lazySingleton<_i619.UpdateMealUseCase>(
      () => _i619.UpdateMealUseCase(gh<_i658.MealPlannerRepository>()),
    );
    gh.lazySingleton<_i479.GetPostsUseCase>(
      () => _i479.GetPostsUseCase(gh<_i136.PostRepository>()),
    );
    gh.factory<_i1002.UserBloc>(() => _i1002.UserBloc(gh<_i791.UserUseCase>()));
    gh.factory<_i1021.PostBloc>(
      () => _i1021.PostBloc(gh<_i479.GetPostsUseCase>()),
    );
    gh.factory<_i138.WeekMenuBloc>(
      () => _i138.WeekMenuBloc(
        getWeekMenuUseCase: gh<_i389.GetWeekMenuUseCase>(),
        updateMealUseCase: gh<_i619.UpdateMealUseCase>(),
        deleteMealUseCase: gh<_i740.DeleteMealUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i477.RegisterModule {}
