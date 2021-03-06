import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';

import 'http_service.dart';

abstract class INetworkService {
  Future<dynamic> get(Uri uri, {Map<String, String>? headers});
}

final networkService = Provider<INetworkService>(
  (ref) => HttpService(client: Client()),
);
