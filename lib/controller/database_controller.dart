import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:out_of_stock/helper/SQLDataBaseHelper.dart';
import 'package:out_of_stock/models/product_model.dart';

class ProductController extends GetxController {
  static RxList<Product> productFetchData = <Product>[].obs;
  static List soldOutList = [];
  static RxInt counter = 0.obs;

  getData() async {
    productFetchData.value =
    await SQLDataBaseHelper.sqlDataBaseHelper.fetchAllRecords();
    soldOutList = List.generate(productFetchData.length, (index) => index);
  }

  get productLength => productFetchData.length;

  Future<bool> generateSoldOut() async {
    int a = Random().nextInt(soldOutList.length);
    print(a);
    productFetchData[soldOutList[a]].counterStart = true;

    counter.value = 30;

    while (counter > 0) {
      await Future.delayed(const Duration(seconds: 1), () {
        counter--;
      });
    }

    productFetchData[soldOutList[a]].counterStart = false;
    productFetchData[soldOutList[a]].quantity = 0;
    productFetchData[soldOutList[a]].isSoldOut = true;
    soldOutList.removeAt(a);

    return true;
  }

  addToCart({required int i}) {

    if(productFetchData[i].quantity! > 0){
      if (productFetchData[i].quantity! > 1) {
        productFetchData[i].quantity = productFetchData[i].quantity! - 1;
        update();
      } else {
        productFetchData[i].quantity = productFetchData[i].quantity! - 1;
        soldOutList.remove(i);
        productFetchData[i].isSoldOut = true;
        update();
      }
    }
  }
}
