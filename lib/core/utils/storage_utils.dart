import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  static const _storage = FlutterSecureStorage();

  // Secure Storage Methods
  static Future<void> saveSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> getSecureData(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> removeSecureData(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> clearSecureStorage() async {
    await _storage.deleteAll();
  }

  // Shared Preferences Methods
  static Future<void> saveData<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();

    switch (T) {
      case String:
        await prefs.setString(key, value as String);
        break;
      case int:
        await prefs.setInt(key, value as int);
        break;
      case bool:
        await prefs.setBool(key, value as bool);
        break;
      case double:
        await prefs.setDouble(key, value as double);
        break;
      case const (List<String>):
        await prefs.setStringList(key, value as List<String>);
        break;
      default:
        throw UnsupportedError('Type ${T.toString()} is not supported');
    }
  }

  static Future<T?> getData<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();

    switch (T) {
      case String:
        return prefs.getString(key) as T?;
      case int:
        return prefs.getInt(key) as T?;
      case bool:
        return prefs.getBool(key) as T?;
      case double:
        return prefs.getDouble(key) as T?;
      case const (List<String>):
        return prefs.getStringList(key) as T?;
      default:
        throw UnsupportedError('Type ${T.toString()} is not supported');
    }
  }

  static Future<bool> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  static Future<bool> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  static Future<bool> hasData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
