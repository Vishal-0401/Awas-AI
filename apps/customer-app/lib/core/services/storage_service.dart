import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  StorageService._privateConstructor();
  static final StorageService instance = StorageService._privateConstructor();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late Box _preferencesBox;

  Future<void> init() async {
    _preferencesBox = await Hive.openBox('preferences');
  }

  // Secure Storage (Tokens, Sensitive Data)
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  // Hive Storage (Preferences, Cache)
  Future<void> setPreference(String key, dynamic value) async {
    await _preferencesBox.put(key, value);
  }

  dynamic getPreference(String key, {dynamic defaultValue}) {
    return _preferencesBox.get(key, defaultValue: defaultValue);
  }
}
