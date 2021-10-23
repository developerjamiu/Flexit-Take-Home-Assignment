import 'package:get_storage/get_storage.dart';

import '../base/failure.dart';
import 'i_key_value_storage_service.dart';

class GetStorageService implements IKeyValueStorageService {
  final _storage = GetStorage();

  @override
  Future<void> save({required String key, required dynamic value}) async {
    await _storage.write(key, value);
  }

  @override
  T? read<T>({required String key}) {
    final data = _storage.read(key);

    if (data == null) throw Failure('Please check your internet connection');

    return data;
  }

  @override
  Future<void> delete({required String key}) async {
    return await _storage.remove(key);
  }
}
