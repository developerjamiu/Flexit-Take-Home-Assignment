import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flexit/src/features/users/models/user.dart';
import 'package:flexit/src/features/users/models/user_detail.dart';
import 'package:flexit/src/repositories/user_repository.dart';
import 'package:flexit/src/services/base/api_constants.dart';
import 'package:flexit/src/services/base/failure.dart';
import 'package:flexit/src/services/key_value_storage/i_key_value_storage_service.dart';
import 'package:flexit/src/services/network/i_network_service.dart';
import 'package:flexit/src/services/network_info/i_network_info_service.dart';

final mockUserObject = {
  "id": "60d0fe4f5311236168a109ca",
  "title": "ms",
  "firstName": "Sara",
  "lastName": "Andersen",
  "picture": "https://randomuser.me/api/portraits/women/58.jpg",
  "gender": "female",
  "email": "sara.andersen@example.com",
  "dateOfBirth": "1996-04-30T19:26:49.610Z",
  "phone": "92694011",
  "location": {
    "street": "9614, SÃ¸ndermarksvej",
    "city": "Kongsvinger",
    "state": "Nordjylland",
    "country": "Denmark",
    "timezone": "-9:00"
  },
  "registerDate": "2021-06-21T21:02:07.374Z",
  "updatedDate": "2021-06-21T21:02:07.374Z"
};

class MockNetworkService extends Mock implements INetworkService {}

class MockNetworkInfoService extends Mock implements INetworkInfoService {}

class MockStorageService extends Mock implements IKeyValueStorageService {}

void main() {
  late MockNetworkService mockNetworkService;
  late MockNetworkInfoService mockNetworkInfoService;
  late MockStorageService mockStorageService;
  late UserRepository userRepository;

  setUp(() {
    mockNetworkService = MockNetworkService();
    mockNetworkInfoService = MockNetworkInfoService();
    mockStorageService = MockStorageService();
    userRepository = UserRepository(
      networkService: mockNetworkService,
      networkInfoService: mockNetworkInfoService,
      storageService: mockStorageService,
    );
  });

  void runTestsOnline(Function body) {
    group('Device is online', () {
      setUp(() {
        when(() => mockNetworkInfoService.isConnected).thenAnswer(
          (_) async => true,
        );
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('Device is offline', () {
      setUp(() {
        when(() => mockNetworkInfoService.isConnected).thenAnswer(
          (_) async => false,
        );
      });

      body();
    });
  }

  group('Get List of Users', () {
    String query = 'limit=20&page=1';

    runTestsOnline(
      () {
        test(
          'Should return remote users when remote fetch is successful',
          () async {
            when(
              () => mockNetworkService.get(
                APIConstants.getUsers(query: query),
                headers: {'app-id': APIConstants.appId},
              ),
            ).thenAnswer((_) async => Future.value({'data': []}));

            when(
              () => mockStorageService.save(
                key: usersKey,
                value: jsonEncode({'data': []}),
              ),
            ).thenAnswer((_) async => Future.value());

            final users = await userRepository.getUsers();

            expect(users, equals(<User>[]));
          },
        );

        test(
          'Should cache the data locally when the call to remote data source is successful',
          () async {
            when(
              () => mockNetworkService.get(
                APIConstants.getUsers(query: query),
                headers: {'app-id': APIConstants.appId},
              ),
            ).thenAnswer((_) async => Future.value({'data': []}));

            when(
              () => mockStorageService.save(
                key: usersKey,
                value: jsonEncode({'data': []}),
              ),
            ).thenAnswer((_) async => Future.value());

            await userRepository.getUsers();

            verify(
              () => mockStorageService.save(
                key: usersKey,
                value: jsonEncode({'data': []}),
              ),
            );
          },
        );

        test(
          'Should throw failure when remote users fetch is unsuccessful',
          () async {
            when(
              () => mockNetworkService.get(
                APIConstants.getUsers(query: query),
                headers: {'app-id': APIConstants.appId},
              ),
            ).thenThrow(
              Failure(''),
            );

            when(
              () => mockStorageService.save(
                key: usersKey,
                value: jsonEncode({'data': []}),
              ),
            ).thenAnswer((_) async => Future.value());

            expect(userRepository.getUsers(), throwsA(isA<Failure>()));
          },
        );
      },
    );

    runTestsOffline(() {
      test(
        'Should return last locally cached list of users when the cached data is present',
        () async {
          when(() => mockStorageService.read(key: usersKey)).thenReturn(
            json.encode({'data': []}),
          );

          final users = await userRepository.getUsers();

          expect(users, equals(<User>[]));
        },
      );

      test(
        'Should return Failure when there is no cached users data present',
        () async {
          when(() => mockStorageService.read(key: usersKey)).thenThrow(
            Failure(''),
          );

          expect(userRepository.getUsers(), throwsA(isA<Failure>()));
        },
      );
    });
  });

  group('Get User Details', () {
    const mockUserId = '1';
    runTestsOnline(
      () {
        test(
          'Should return remote user details when remote fetch is successful',
          () async {
            when(
              () => mockNetworkService.get(
                APIConstants.getUser(mockUserId),
                headers: {'app-id': APIConstants.appId},
              ),
            ).thenAnswer((_) async => Future.value(mockUserObject));

            when(
              () => mockStorageService.save(
                key: mockUserId,
                value: jsonEncode(mockUserObject),
              ),
            ).thenAnswer((_) async => Future.value());

            final userDetails = await userRepository.getUser(mockUserId);

            expect(userDetails, isA<UserDetail>());
          },
        );

        test(
          'Should cache the data locally when the call to remote data source is successful',
          () async {
            when(
              () => mockNetworkService.get(
                APIConstants.getUser(mockUserId),
                headers: {'app-id': APIConstants.appId},
              ),
            ).thenAnswer(
              (_) => Future.value(mockUserObject),
            );

            when(
              () => mockStorageService.save(
                key: mockUserId,
                value: jsonEncode(mockUserObject),
              ),
            ).thenAnswer((_) async => Future.value());

            await userRepository.getUser(mockUserId);

            verify(
              () => mockStorageService.save(
                key: mockUserId,
                value: jsonEncode(mockUserObject),
              ),
            );
          },
        );

        test(
          'Should throw failure when remote user details fetch is unsuccessful',
          () async {
            when(
              () => mockNetworkService.get(
                APIConstants.getUser(mockUserId),
                headers: {'app-id': APIConstants.appId},
              ),
            ).thenThrow(
              Failure(''),
            );

            when(
              () => mockStorageService.save(
                key: usersKey,
                value: jsonEncode(mockUserObject),
              ),
            ).thenAnswer((_) async => Future.value());

            expect(userRepository.getUser(mockUserId), throwsA(isA<Failure>()));
          },
        );
      },
    );

    runTestsOffline(() {
      test(
        'Should return last locally cached user details when the cached data is present',
        () async {
          when(() => mockStorageService.read(key: mockUserId)).thenReturn(
            json.encode(mockUserObject),
          );

          final userDetails = await userRepository.getUser(mockUserId);

          expect(userDetails, isA<UserDetail>());
        },
      );

      test(
        'Should return Failure when there is no cached user details data present',
        () async {
          when(() => mockStorageService.read(key: mockUserId)).thenThrow(
            Failure(''),
          );

          expect(userRepository.getUser(mockUserId), throwsA(isA<Failure>()));
        },
      );
    });
  });
}
