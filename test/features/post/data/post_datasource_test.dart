
import 'package:clean_architecture_sample/features/post/data/datasource/post_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../users/data/datasource_test.mocks.dart';

void main() {
  late MockDio dio;
  late PostRemoteDatasourceImpl datasource;

  setUp(() {
    dio = MockDio();
    datasource = PostRemoteDatasourceImpl(dio);
  });

  group("Post Datasource test", (){
    test("Return valid post data", () async {
      when(dio.get(any)).thenAnswer((_) async {
        return Response(
          data: [{"id": 1, "title": "Ajith", "body": "test"}],
            statusCode: 200,
            requestOptions: RequestOptions(path: ""));
      });

      final response = await datasource.getPosts();
      expect(response.first.title, "Ajith");
    });
  });
}