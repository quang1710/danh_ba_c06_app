// database_local_impl.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'database_local.dart';

class DatabaseChatImpl implements DatabaseChat {
  static final DatabaseChatImpl _instance = DatabaseChatImpl._internal();
  factory DatabaseChatImpl() => _instance;

  static Database? _database;
  static String? _dbName;
  DatabaseChatImpl._internal();

  @override
  Future<Database> getDatabase({required String dbName}) async {
    _dbName = dbName;
    if (_database != null) return _database!;
    if (await _databaseExists(dbName)) {
      print('Database đã tồn tại');
      _database = await _openDatabase(dbName);
    } else {
      print('Khởi tạo database mới');
      _database = await _initDatabase(dbName);
    }
    return _database!;
  }

  Future<bool> _databaseExists(String dbName) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    return await databaseExists(path);
  }

  Future<Database> _openDatabase(String dbName) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);
    return await openDatabase(path);
  }

  // Các câu lệnh tạo bảng trong cơ sở dữ liệu
  final List<String> tableCreationQueries = [
    '''
    CREATE TABLE users (
      user_id INTEGER PRIMARY KEY,
      avatar TEXT,
      role TEXT,
      phone VARCHAR(15),
      username VARCHAR(30),
      full_name VARCHAR(30)
    )
    ''',
    '''
    CREATE TABLE single_chats (
      single_chat_id INTEGER PRIMARY KEY,
      user_id INTEGER,
      last_message TEXT,
      last_message_id INTEGER,
      last_message_sent_at DATETIME,
      unseen_number INTEGER
    )
    ''',
    '''
    CREATE TABLE group_chats (
      group_chat_id INTEGER PRIMARY KEY,
      group_name VARCHAR(50),
      group_members TEXT,
      avatar TEXT,
      last_message TEXT,
      last_message_id INTEGER,
      last_message_sent_at DATETIME,
      unseen_number INTEGER
    )
    ''',
    '''
    CREATE TABLE single_messages (
      message_id INTEGER PRIMARY KEY,
      FK_user_id INTEGER,
      FK_chat_id INTEGER,
      content TEXT,
      attachments TEXT,
      emoji TEXT,
      sent_at DATETIME,
      FOREIGN KEY (FK_user_id) REFERENCES users (user_id),
      FOREIGN KEY (FK_chat_id) REFERENCES single_chats (single_chat_id)
    )
    ''',
    '''
    CREATE TABLE group_messages (
      message_id INTEGER PRIMARY KEY,
      FK_user_id INTEGER,
      FK_chat_id INTEGER,
      content TEXT,
      emoji TEXT,
      attachments TEXT,
      sent_at DATETIME,
      FOREIGN KEY (FK_user_id) REFERENCES users (user_id),
      FOREIGN KEY (FK_chat_id) REFERENCES group_chats (group_chat_id)
    )
    '''
  ];

  Future<Database> _initDatabase(String dbName) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Tạo bảng khi khởi tạo database
  Future<void> _onCreate(Database db, int version) async {
    for (String query in tableCreationQueries) {
      await db.execute(query);
    }
  }

  @override
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      print('Đã đóng database $_dbName');
    }
  }

  // Hàm tạo bảng
  @override 
  Future<void> createTable() async {
    Database db = await getDatabase(dbName: _dbName!);
    for (String query in tableCreationQueries) {
      await db.execute(query);
    }
  }

  // Hàm thêm người dùng
  @override
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await getDatabase(dbName: _dbName!);
    return await db.insert('users', row);
  }

  // Hàm chỉnh sửa người dùng theo ID
  @override
  Future<int> updateUserById(Map<String, dynamic> row) async {
    int id = row['user_id'];
    Database db = await getDatabase(dbName: _dbName!);

    return await db.update(
      'users',
      row,
      where: 'user_id = ?',
      whereArgs: [id],
    );
  }

  // Hàm thêm 1 chat cá nhân
  @override
  Future<int> insertSingleChat(Map<String, dynamic> row) async {
    Database db = await getDatabase(dbName: _dbName!);
    return await db.insert('single_chats', row);
  }

  // Hàm thêm 1 nhóm chat
  @override
  Future<int> insertGroupChat(Map<String, dynamic> row) async {
    Database db = await getDatabase(dbName: _dbName!);
    return await db.insert('group_chats', row);
  }

  @override
  Future<int> insertSingleMessage(Map<String, dynamic> row) async {
    Database db = await getDatabase(dbName: _dbName!);
    return await db.insert('single_messages', row);
  }
}