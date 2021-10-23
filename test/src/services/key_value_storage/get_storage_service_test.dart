import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flexit/src/services/base/failure.dart';
import 'package:flexit/src/services/key_value_storage/get_storage_service.dart';
import 'package:flexit/src/services/key_value_storage/i_key_value_storage_service.dart';

class MockGetStorage extends Mock implements GetStorage {}

void main() {
  late MockGetStorage mockGetStorage;
  late IKeyValueStorageService getStorageService;

  setUp(() {
    mockGetStorage = MockGetStorage();
    getStorageService = GetStorageService(storage: mockGetStorage);
  });

  group('Get storage service methods test', () {
    test('Should write to database when save is called', () async {
      when(() => mockGetStorage.write('key', 'value')).thenAnswer(
        (_) => Future.value(),
      );

      await getStorageService.save(key: 'key', value: 'value');

      verify(() => mockGetStorage.write('key', 'value'));
    });

    test('Should read from database when read is called and there is value',
        () async {
      when(() => mockGetStorage.read('key')).thenReturn('value');

      final result = await getStorageService.read(key: 'key');

      verify(() => mockGetStorage.read('key'));
      expect(result, 'value');
    });

    test('Should read from database when read is called and there is no value',
        () async {
      when(() => mockGetStorage.read('key')).thenReturn(null);

      expect(() => getStorageService.read(key: 'key'), throwsA(isA<Failure>()));
    });

    test('Should remove from database when delete is called', () async {
      when(() => mockGetStorage.remove('key')).thenAnswer(
        (_) => Future.value(),
      );

      await getStorageService.delete(key: 'key');

      verify(() => mockGetStorage.remove('key'));
    });
  });
}
