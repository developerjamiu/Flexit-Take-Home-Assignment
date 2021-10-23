import 'api_credentials.dart';

class APIConstants {
  static const host = 'dummyapi.io';
  static const String scheme = 'https';
  static const appId = APICredentials.appId;

  static Uri getUsers({String? query}) => Uri(
        scheme: scheme,
        host: host,
        path: '/data/v1/user',
        query: query,
      );

  static Uri getUser(String userId) => Uri(
        scheme: scheme,
        host: host,
        path: 'data/v1/user/$userId',
      );
}
