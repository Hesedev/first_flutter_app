import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'contact_manager.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            phone TEXT,
            address TEXT
          )
        ''');

        await db.insert('contacts', {
          'name': 'John Doe',
          'email': 'john.doe@example.com',
          'phone': '123-456-7890',
          'address': '123 Main St',
        });

        await db.insert('contacts', {
          'name': 'Jane Smith',
          'email': 'jane.smith@example.com',
          'phone': '098-765-4321',
          'address': '456 Oak Ave',
        });
      },
    );

    return _database!;
  }
}
