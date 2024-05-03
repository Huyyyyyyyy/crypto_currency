import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteConfiguration {
  final db_name = 'crypto_currency.db';

  String TABLE_ORDER = 'create table orders '
      '('
      'client_order_id text primary key,'
      'order_id text,'
      'symbol text,'
      'side text,'
      'type text,'
      'position_side text,'
      'status text,'
      'update_time text'
      ')';
  String TABLE_ACCOUNT = 'create table accounts'
      '('
      'user_name text,'
      'password text,'
      'api_key text primary key,'
      'secret_key text'
      ')';

  Future<Database> openDB () async {
    final databasePath = await getDatabasesPath();
    print(databasePath);
    final path = join(databasePath, db_name);
    var ourDb = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return ourDb;
  }

  void _onCreate(Database db, int version) async{
    await db.execute(TABLE_ORDER);
    await db.execute(TABLE_ACCOUNT);
    print('open database : $db_name');
  }


  void _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if (oldVersion < newVersion) {
      // await db.execute("ALTER TABLE orders RENAME COLUMN ""updateTime"" TO update_time");
    }
  }
}