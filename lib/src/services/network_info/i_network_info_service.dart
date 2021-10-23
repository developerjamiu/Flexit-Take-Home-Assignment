import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'internet_connection_checker_service.dart';

abstract class INetworkInfoService {
  Future<bool> get isConnected;
}

final networkInfoService = Provider<INetworkInfoService>(
  (ref) => InternetConnectionCheckerService(),
);
