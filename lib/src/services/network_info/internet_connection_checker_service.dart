import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'i_network_info_service.dart';

class InternetConnectionCheckerService implements INetworkInfoService {
  InternetConnectionCheckerService({required this.connectionChecker});

  final InternetConnectionChecker connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
