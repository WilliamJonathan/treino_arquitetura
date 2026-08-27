import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' show databaseFactoryFfi, sqfliteFfiInit;

/// Fake API local com SQLite.
///
/// Em desktop (Windows/Linux/macOS) usamos sqflite_common_ffi.
/// Em mobile, usamos o databaseFactory padrão do sqflite.
class ClienteDatabase {
  static final ClienteDatabase _instance = ClienteDatabase._internal();

  factory ClienteDatabase() => _instance;

  static ClienteDatabase get instance => _instance;

  ClienteDatabase._internal();

  Database? _db;
  bool _initialized = false;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    _initialized = true;
  }

  Future<Database> _open() async {
    await _ensureInitialized();

    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = p.join(dir.path, 'treino_arquitetura_clientes.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE clientes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            apelido TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
