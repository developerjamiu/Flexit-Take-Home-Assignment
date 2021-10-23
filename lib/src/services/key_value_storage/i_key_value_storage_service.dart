import 'package:get_storage/get_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'get_storage_service.dart';

abstract class IKeyValueStorageService {
  Future<void> save({required String key, required dynamic value});

  T? read<T>({required String key});

  Future<void> delete({required String key});
}

final keyValueStorageService = Provider<IKeyValueStorageService>(
  (ref) => GetStorageService(storage: GetStorage()),
);
