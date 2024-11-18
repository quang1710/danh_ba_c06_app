import 'package:sqflite/sqflite.dart';

abstract class DatabaseChat {
  Future<Database> getDatabase({required String dbName});
  Future<void> closeDatabase();
  Future<void> createTable();
  Future<int> insertUser(Map<String, dynamic> row);
  Future<int> updateUserById(Map<String, dynamic> row);
  Future<int> insertSingleChat(Map<String, dynamic> row);
  Future<int> insertGroupChat(Map<String, dynamic> row);
  Future<int> insertSingleMessage(Map<String, dynamic> row);
}