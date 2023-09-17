import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';

class SQLDataBaseHelper {
  SQLDataBaseHelper._();

  static final SQLDataBaseHelper sqlDataBaseHelper = SQLDataBaseHelper._();

  Database? dbs;

  String tableName = "product";
  String column1_ID = "id";
  String column2_name = "name";
  String column3_image = "image";
  String column4_quantity = "quantity";

  Future<void> createDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = dbPath + "/product.db";

    dbs = await openDatabase(
      path,
      version: 1,
      onCreate: (Database database, version) async {
        String query =
            "CREATE TABLE IF NOT EXISTS $tableName($column1_ID INTEGER PRIMARY KEY AUTOINCREMENT, $column2_name TEXT, $column3_image TEXT, $column4_quantity INTEGER);";
        await database.execute(query);
      },
    );
  }

  Future<int?> insertRecord({required Product data}) async {

    String query =
        "INSERT INTO $tableName VALUES(null,'${data.name}', '${data.image}', ${data.quantity})";

    return await dbs?.rawInsert(query);
  }

  Future<void> loadString({required String path}) async {

    await createDatabase();


    String productData = await rootBundle.loadString(path);
    List<Product> productList = productFromJson(productData);

    for (var product in productList) {
      await insertRecord(data: product);
      print("record inserted");
    }
  }


  Future<List<Product>> fetchAllRecords() async {
    await createDatabase();
    String query = "SELECT * FROM $tableName";
    List<Map<String, dynamic>> productList = await dbs!.rawQuery(query);
    return productList.map((e) => Product.fromJson(json: e)).toList();
  }
}
