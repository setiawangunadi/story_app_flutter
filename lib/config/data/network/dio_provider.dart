import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:story_app/config/data/local/constants.dart';
import 'package:story_app/config/data/local/shared_prefs_storage.dart';

class DioProvider {
  final Dio dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

  DioProvider._privateConstructor();

  static final DioProvider _instance = DioProvider._privateConstructor();

  factory DioProvider() => _instance;

  Future<Response> get({required String path, Map<String, dynamic>? queryParameters}) async {
    try {
      var tokenId = await SharedPrefsStorage.getTokenId();

      final response = await dio.get(
        '$baseUrl$path',
        queryParameters: queryParameters,
        options: Options(
          headers: {"Authorization": "Bearer $tokenId"},
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Gagal melakukan permintaan GET: $e');
    }
  }

  Future<Response> post(
      {required String path,
      dynamic data,
      Options? options,
      String? contentType}) async {
    try {
      var tokenId = await SharedPrefsStorage.getTokenId();

      final response = await dio.post(
        '$baseUrl$path',
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer $tokenId",
            'Content-Type': contentType?.isEmpty == true ? '' : contentType,
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Gagal melakukan permintaan POST: $e');
    }
  }
}
