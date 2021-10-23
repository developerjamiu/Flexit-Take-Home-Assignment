import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../base/failure.dart';
import 'i_network_service.dart';

class HttpService implements INetworkService {
  final log = Logger();

  final Client client;

  HttpService({required this.client});

  void _throwOnFail(Response res) {
    if (res.statusCode != HttpStatus.ok) {
      log.d('Error Code: ${res.statusCode}');

      final failure = Failure.fromHttpErrorMap(json.decode(res.body));
      log.e('Error Message: ${failure.message}');

      throw failure;
    }
  }

  @override
  Future<dynamic> get(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await client.get(uri, headers: headers);

      _throwOnFail(response);

      return jsonDecode(response.body);
    } on SocketException {
      throw Failure('Please check your internet connection 😑');
    } on FormatException {
      throw Failure('Bad response format 👎');
    } on HttpException {
      throw Failure('Please check your internet connection');
    } catch (ex) {
      rethrow;
    }
  }
}
