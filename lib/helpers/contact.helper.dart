import 'package:lista_contatos/helpers/contact.field.table.dart';
import 'package:lista_contatos/helpers/contact.model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContactHelper {

  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerVersion) async {
        await db.execute(
          "CREATE TABLE ${ContactFieldTable.tableName}("
            "${ContactFieldTable.id} INTEGER PRIMARY KEY,"
            "${ContactFieldTable.name} TEXT,"
            "${ContactFieldTable.email} TEXT,"
            "${ContactFieldTable.phone} TEXT,"
            "${ContactFieldTable.img} TEXT"
          ")"
        );
      }
    );
  }

  Future<ContactModel> saveContact(ContactModel contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(
      ContactFieldTable.tableName,
      contact.toMap()
    );
    return contact;
  }

  Future<ContactModel> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(
      ContactFieldTable.tableName,
      columns: [
        ContactFieldTable.id,
        ContactFieldTable.name,
        ContactFieldTable.email,
        ContactFieldTable.phone,
        ContactFieldTable.img
      ],
      where: "${ContactFieldTable.id} = ?",
      whereArgs: [id]
    );
    if (maps.length > 0) {
      return ContactModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(
      ContactFieldTable.tableName,
      where: "${ContactFieldTable.id} = ?",
      whereArgs: [id]
    );
  }

  Future<int> updateContact(ContactModel contact) async {
    Database dbContact = await db;
    return await dbContact.update(
      ContactFieldTable.tableName,
      contact.toMap(),
      where: "${ContactFieldTable.id} = ?",
      whereArgs: [contact.id]
    );
  }

  Future<List<ContactModel>> getAllContacts() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery(
      "SELECT * FROM ${ContactFieldTable.tableName}"
    );
    List<ContactModel> listContact = List();
    listMap.forEach(
      (map) => listContact.add(ContactModel.fromMap(map))
    );
    return listContact;
  }

  Future<int> getCount() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(
      await dbContact.rawQuery(
        "SELECT * FROM ${ContactFieldTable.tableName}"
      )
    );
  }

  Future close() async {
    Database dbContact = await db;
    await dbContact.close();
  }

}