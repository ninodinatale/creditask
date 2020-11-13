import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _jwtStorageKey = 'creditask_jwt';
final _storage = new FlutterSecureStorage();

Future<String> getJwt() async {
  String value = await _storage.read(key: _jwtStorageKey);
  return value;
}

Future<void> setJwt(String token) async {
  await _storage.write(key: _jwtStorageKey, value: token);
}

Future<void> deleteJwt() async {
  await _storage.delete(key: _jwtStorageKey);
}
