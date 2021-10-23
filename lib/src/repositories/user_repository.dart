import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../features/users/models/user.dart';
import '../features/users/models/user_detail.dart';
import '../services/base/api_constants.dart';
import '../services/key_value_storage/i_key_value_storage_service.dart';
import '../services/network/i_network_service.dart';
import '../services/network_info/i_network_info_service.dart';

const usersKey = 'usersKey';

class UserRepository {
  final log = Logger();

  final INetworkService networkService;
  final INetworkInfoService networkInfoService;
  final IKeyValueStorageService storageService;

  UserRepository({
    required this.networkService,
    required this.networkInfoService,
    required this.storageService,
  });

  Future<List<User>> getUsers({int page = 1, int pageSize = 20}) async {
    if (await networkInfoService.isConnected) {
      final uri = APIConstants.getUsers(query: 'limit=$pageSize&page=$page');

      final response = await networkService.get(
        uri,
        headers: {'app-id': APIConstants.appId},
      );

      // Store only first twenty users in cache
      if (page == 1) {
        await storageService.save(key: usersKey, value: json.encode(response));
      }

      return UsersResponse.fromMap(response).users;
    } else {
      // Retrieve from cache only when page is 1
      if (page == 1) {
        final usersFromCache = storageService.read(key: usersKey);

        final users = json.decode(usersFromCache);

        return UsersResponse.fromMap(users).users;
      }
      return [];
    }
  }

  Future<UserDetail> getUser(String userId) async {
    if (await networkInfoService.isConnected) {
      final uri = APIConstants.getUser(userId);

      final response = await networkService.get(
        uri,
        headers: {'app-id': APIConstants.appId},
      );

      await storageService.save(
        key: userId,
        value: json.encode(response),
      );

      return UserDetail.fromMap(response);
    } else {
      final userDetailsFromCache = storageService.read(key: userId);

      final users = json.decode(userDetailsFromCache);

      return UserDetail.fromMap(users);
    }
  }
}

final usersRepository = Provider<UserRepository>(
  (ref) => UserRepository(
    networkService: ref.watch(networkService),
    networkInfoService: ref.watch(networkInfoService),
    storageService: ref.watch(keyValueStorageService),
  ),
);
