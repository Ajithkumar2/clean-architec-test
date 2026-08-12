

import 'package:clean_architecture_sample/core/failures.dart';
import 'package:clean_architecture_sample/features/post/data/datasource/post_remote_datasource.dart';
import 'package:clean_architecture_sample/features/post/data/model/post_model.dart';
import 'package:clean_architecture_sample/features/post/data/repositories/post_repository_impl.dart';
import 'package:clean_architecture_sample/features/post/domain/enitites/post_entity.dart';
import 'package:clean_architecture_sample/features/users/data/model/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_repository_test.mocks.dart';

@GenerateMocks([PostRemoteDatasource])

void main() {
 late MockPostRemoteDatasource datasource;
 late PostRepositoryImpl repository;

 setUp(() {
   datasource = MockPostRemoteDatasource();
   repository = PostRepositoryImpl(datasource);
 });

 test("should return Post", () async {
   final post = PostModel(id: 1, title: "Ajith", body: "test");
   var result = <PostModel>[post];
   when(datasource.getPosts()).thenAnswer((_) async => result);

   final testResult = await repository.getPosts();
   expect(testResult.isRight(), true);
 });

 test("Should return NetworkFailure", () async {
   when(datasource.getPosts()).thenThrow(DioException(requestOptions: RequestOptions(path: '')));
   final testResult = await repository.getPosts();
   expect(testResult, equals(Left(NetworkFailure())));
   // testResult.fold(
   //       (failure) => expect(failure, isA<NetworkFailure>()), // Expect type instead of instance
   //       (success) => fail('Expected a failure but got success data'), // Fails test if it returns Right
   // );
 });
}