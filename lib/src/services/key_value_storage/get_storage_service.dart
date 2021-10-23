import 'package:get_storage/get_storage.dart';

import '../base/failure.dart';
import 'i_key_value_storage_service.dart';

class GetStorageService implements IKeyValueStorageService {
  GetStorageService({required this.storage});

  final GetStorage storage;

  @override
  Future<void> save({required String key, required dynamic value}) async {
    await storage.write(key, value);
  }

  @override
  T? read<T>({required String key}) {
    final data = storage.read(key);

    if (data != null) return data;

    throw Failure('Please check your internet connection');
  }

  @override
  Future<void> delete({required String key}) async {
    await storage.remove(key);
  }
}
