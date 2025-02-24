import 'package:dio/dio.dart';
import 'package:instagram_clone_app/core/web_services/firebase_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  static Dio? dio;

  static initDioHelper() async {
    dio = Dio(BaseOptions(
        baseUrl:
            "https://fcm.googleapis.com/v1/projects/insta-app-ebc41/messages:send",
        receiveDataWhenStatusError: true,
              headers: {
        "Authorization": "Bearer ${await GetServerKey.getServerKeyToken()}",  // 🔹 Add OAuth 2.0 token
      },
       ));

    dio!.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));
  }

  static Future<Response> postData(
      String token, String title, String body) async {
    return await dio!.post(
      "",
      data: {
        "message": {
          "token": token,
          "notification": {"title": title, "body": body}
        }
      },
    );
  }
}