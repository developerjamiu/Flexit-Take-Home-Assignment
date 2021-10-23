import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flexit/src/services/network_info/i_network_info_service.dart';
import 'package:flexit/src/services/network_info/internet_connection_checker_service.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late INetworkInfoService networkInfoService;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoService = InternetConnectionCheckerService(
      connectionChecker: mockInternetConnectionChecker,
    );
  });

  group('Network info service methods test', () {
    test('Should return true when there is connection', () async {
      when(() => mockInternetConnectionChecker.hasConnection).thenAnswer(
        (_) async => true,
      );

      final result = await networkInfoService.isConnected;

      expect(result, true);
    });

    test('Should return false when there is no connection', () async {
      when(() => mockInternetConnectionChecker.hasConnection).thenAnswer(
        (_) async => false,
      );

      final result = await networkInfoService.isConnected;

      expect(result, false);
    });
  });
}
