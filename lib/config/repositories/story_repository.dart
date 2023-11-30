import 'package:dio/dio.dart';
import 'package:story_app/config/data/network/canonical_path.dart';
import 'package:story_app/config/data/network/dio_provider.dart';

class StoryRepository {
  Future<Response> getListStory({
    required int page,
    required int size,
  }) async {
    Map<String, dynamic>? queryParams = {"page": page, "size": size};

    final response = DioProvider().get(
      path: CanonicalPath.listStory,
      queryParameters: queryParams,
    );
    return response;
  }

  Future<Response> getDetailStory({required String id}) async {
    final response = DioProvider().get(
      path: "${CanonicalPath.listStory}/$id",
    );
    return response;
  }

  Future<Response> doAddStory({
    required String description,
    required String imagePath,
    required String imageName,
    dynamic latitude,
    dynamic longitude,
  }) async {
    FormData formData = FormData.fromMap({
      'description': description,
      'photo': await MultipartFile.fromFile(imagePath, filename: imageName),
      'lat': latitude ?? 0,
      'lon': longitude ?? 0,
    });

    final response = DioProvider().post(
      path: CanonicalPath.listStory,
      data: formData,
    );
    return response;
  }
}
