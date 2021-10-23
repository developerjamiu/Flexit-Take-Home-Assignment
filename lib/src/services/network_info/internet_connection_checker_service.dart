import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'i_network_info_service.dart';

class InternetConnectionCheckerService implements INetworkInfoService {
  final _connectionChecker = InternetConnectionChecker();

  @override
  Future<bool> get isConnected => _connectionChecker.hasConnection;
}
