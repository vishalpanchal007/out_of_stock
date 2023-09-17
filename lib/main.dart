import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:out_of_stock/views/home_screen.dart';

import 'controller/database_controller.dart';
import 'helper/SQLDataBaseHelper.dart';

Future<void> main() async {
  await GetStorage.init();
  ProductController productController = Get.put(ProductController());
  await GetStorage.init();
  final box = GetStorage();

  bool isAppInit = box.read('isAppInit') ?? false;

  if(!isAppInit){
    await SQLDataBaseHelper.sqlDataBaseHelper.loadString(path: "assets/product_data.json");
    box.write('isAppInit', true);
    print("----------------------------");
    print("App  init");
    print("----------------------------");
  }

  productController.getData();

  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}
