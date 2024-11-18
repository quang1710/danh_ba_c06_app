import 'package:shared_preferences/shared_preferences.dart';

// Class thao tác với SharedPreferences
class StorageHelper {
  static SharedPreferences? _prefs;

  // Khởi tạo singleton cho SharedPreferences
  static Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Lấy giá trị kiểu String
  static Future<String?> getString(String key) async {
    await _initPrefs();
    return _prefs?.getString(key);
  }

  // Lưu giá trị, hỗ trợ nhiều kiểu dữ liệu
  static Future<void> set(String key, dynamic value) async {
    await _initPrefs();
    if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is bool) {
      await _prefs?.setBool(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs?.setStringList(key, value);
    } else {
      throw ArgumentError('Unsupported value type: ${value.runtimeType}');
    }
  }

  // Xóa giá trị theo key
  static Future<void> remove(String key) async {
    await _initPrefs();
    await _prefs?.remove(key);
  }

  // Xóa tất cả dữ liệu
  static Future<void> clear() async {
    await _initPrefs();
    await _prefs?.clear();
  }
}