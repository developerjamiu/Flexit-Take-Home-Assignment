import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'internet_connection_checker_service.dart';

abstract class INetworkInfoService {
  Future<bool> get isConnected;
}

final networkInfoService = Provider<INetworkInfoService>(
  (ref) => InternetConnectionCheckerService(
    connectionChecker: InternetConnectionChecker(),
  ),
);
