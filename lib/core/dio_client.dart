import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@lazySingleton
class DioClient {
  DioClient._internal();

  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late Dio dio;

  void init() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      )
    );

    dio.interceptors.add(PrettyDioLogger());

// customization
   dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
        // filter: (options, args){
        //     // don't print requests with uris containing '/posts' 
        //     if(options.path.contains('/posts')){
        //       return false;
        //     }
        //     // don't print responses with unit8 list data
        //     return !args.isResponse || !args.hasUint8ListData;
        //   }
      )
    );
  }
}