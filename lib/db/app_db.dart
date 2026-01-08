import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDb {
  AppDb._();

  static final AppDb instance = AppDb._();

  static const _dbName = 'lenscart.db';
  static const _dbVersion = 3;

  Database? _db;

  Future<Database> get db async {
    final existing = _db;
    if (existing != null) return existing;

    final base = await getDatabasesPath();
    final path = p.join(base, _dbName);

    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE seller_products(
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              description TEXT NOT NULL,
              imageAsset TEXT NOT NULL,
              imageUrl TEXT,
              category TEXT NOT NULL,
              audience TEXT NOT NULL,
              shape TEXT NOT NULL,
              price REAL NOT NULL,
              mrp REAL,
              sellerId TEXT
            )
            '''
          );

        await db.execute('''
            CREATE TABLE buyer_profile(
              id INTEGER PRIMARY KEY,
              name TEXT,
              phone TEXT,
              address TEXT
            )
            '''
          );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
              CREATE TABLE IF NOT EXISTS buyer_profile(
                id INTEGER PRIMARY KEY,
                name TEXT,
                phone TEXT,
                address TEXT
              )
              '''
            );
        }
        if (oldVersion < 3) {
          // Add sellerId column to existing seller_products table
          await db.execute('ALTER TABLE seller_products ADD COLUMN sellerId TEXT');
        }
      },
    );

    return _db!;
  }

  Future<void> close() async {
    final db = _db;
    _db = null;
    await db?.close();
  }
}
