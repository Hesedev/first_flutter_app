import 'package:first_app/database/app_database.dart';
import 'package:first_app/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactRepository {
  static Future<List<Contact>> getContacts() async {
    final Database db = await AppDatabase.getDatabase();
    final result = await db.query('contacts');
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  static Future<int> addContact(Contact contact) async {
    final db = await AppDatabase.getDatabase();
    return await db.insert('contacts', contact.toMap());
  }

  static Future<int> updateContact(Contact contact) async {
    final db = await AppDatabase.getDatabase();
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  static Future<int> deleteContact(int id) async {
    final db = await AppDatabase.getDatabase();
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
