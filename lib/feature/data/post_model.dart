import 'package:clean_architecture_sample/feature/domain/post_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

// data/post_model.dart
class PostModel extends Post {
  PostModel({required super.id, required super.title, required super.body});

  factory PostModel.fromJson(Map<String, dynamic> json) => 
      PostModel(id: json['id'], title: json['title'], body: json['body']);

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'body': body};
}