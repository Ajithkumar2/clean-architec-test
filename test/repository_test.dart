import 'package:clean_architecture_sample/features/post/data/repositories/post_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:sqflite/sqflite.dart';

@GenerateMocks([Dio, Database])
void main() {
  late PostRepositoryImpl postRepositoryImpl;
}