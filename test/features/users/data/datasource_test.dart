
import 'package:clean_architecture_sample/core/network_exceptions.dart';
import 'package:clean_architecture_sample/features/users/data/datasource/users_remote_datasource_impl.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'datasource_test.mocks.dart';



@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late UsersRemoteDatasourceImpl usersRemoteDatasource;

  setUp(() {
    mockDio = MockDio();
    usersRemoteDatasource = UsersRemoteDatasourceImpl(mockDio);
  });

  group('getUsers()', () {
    test("should return List<UserModel> when API succeeds", () async {
      when(mockDio.get(any))
          .thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: [{"id": 1, "name": "Ajith", "email": "ajith@gmail.com"}]));

      final result = await usersRemoteDatasource.getUsers();
      expect(result.length, 1);
      expect(result.first.id, 1);
      expect(result.first.name, "Ajith");
    });

    test("should throw NetworkException", () async {
      when(mockDio.get(any)).thenThrow(
          DioException(requestOptions: RequestOptions(path: '')));
      // final result = await usersRemoteDatasource.getUsers();
      expect(usersRemoteDatasource.getUsers(), throwsA(isA<NetworkException>()));
    });

    test("Should return Server Exception", () async {
      when(mockDio.get(any)).thenThrow(Exception());
      expect(usersRemoteDatasource.getUsers(), throwsA(isA<ServerException>()));
    });
  });
}