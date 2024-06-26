import 'package:crypto_currency/db/sqlite_configuration/sqlite_config.dart';
import 'package:crypto_currency/db/table/table.dart';
import 'package:crypto_currency/services/global_key_storage/global_setting.dart';
import 'package:sqflite/sqflite.dart';
class Accounts {
  String username = '';
  String password = '';
  String apiKey = '';
  String secretKey = '' ;

  Accounts({
    required this.username,
    required this.password,
    required this.apiKey,
    required this.secretKey,
  });

  factory Accounts.fromMap(Map<String, dynamic> json) => Accounts(
      username: json["username"] as String? ?? '',
      password: json["password"] as String? ?? '',
      apiKey: json["api_key"] as String? ?? '',
      secretKey: json["secret_key"] as String? ?? '',
  );

  Map<String, dynamic> toMap() => {
    "username" : username,
    "password" : password,
    "api_key" : apiKey,
    "secret_key" :secretKey,
  };


  static Future<bool> customerRegister(Accounts newAccount) async {
    try{
      Database db = await SQLiteConfiguration().openDB();
      if(await checkAccountExistOrNot(db, newAccount) == true){
        await db.insert(Table.ACCOUNTS,  newAccount.toMap());
        print('add account successfully');
        return true;
      }
      else
      {
        print('account is already exist on db');
        return false;
      }
    }on Exception catch(_){
      print('add position false');
      return false;
    }
  }

  static Future<bool> checkAccountExistOrNot (Database db ,Accounts newAccount) async {
    try {
      List<Map<String, dynamic>> existingAccount = await db.query(
        Table.ACCOUNTS,
        where: 'username = ? AND api_key = ? AND secret_key = ?',
        whereArgs: [newAccount.username, newAccount.apiKey, newAccount.secretKey],
      );

      if (existingAccount.isEmpty) {
        print('check account exist completely ! insert next');
        return true;
      }
      return false;
    }on Exception catch(_){
      print('add account false');
      return false;
    }
  }

  static Future<bool> updateAccount (Database db, Accounts newAccount) async {
    try {
      await db.update(
        Table.ORDERS,
        newAccount.toMap(),
        where: 'api_key = ? AND secret_key = ? AND username = ?',
        whereArgs: [newAccount.apiKey, newAccount.secretKey, newAccount.username],
      );
      print('update account completely');
      return true;
    }on Exception catch(_){
      print('update account false');
      return false;
    }
  }

  static Future<Accounts?> customerLogin(String username, String password) async {
    Database db = await SQLiteConfiguration().openDB();
    List<Map<String, Object?>> result = await db.rawQuery(
      "SELECT * FROM accounts WHERE username = '$username' AND password = '$password'",
    );

    if (result.isNotEmpty) {
      print('Login success');
      Accounts loginAccount = Accounts.fromMap(result.first);
      await GlobalSettings.updateApiKey(loginAccount.apiKey);
      print('update api key successfully');
      await GlobalSettings.updateSecretKey(loginAccount.secretKey);
      print('update secret key successfully');
      return loginAccount;
    } else {
      print('account not exist in db');
      return null;
    }
  }
}