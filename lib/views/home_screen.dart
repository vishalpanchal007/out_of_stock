import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/database_controller.dart';
import '../controller/themeController.dart';
import '../models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductController productController = Get.find<ProductController>();
  ThemeController themeController = Get.put(ThemeController());

  createSoldOut() async {
    await Future.delayed(const Duration(seconds: 5), () async {
      bool res = await productController.generateSoldOut();
      setState(() {});
      if (res) {
        createSoldOut();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    createSoldOut();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text("All Product"),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                themeController.toggleDarkMode();
              },
              icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
        ),
        body: GetBuilder<ProductController>(
          builder: (productController) => (ProductController
              .productFetchData.isEmpty)
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                      itemCount: productController.productLength,
                      itemBuilder: (context, index) {
                        Product product =
                        ProductController.productFetchData[index];
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          clipBehavior: Clip.none,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(0, 2),
                                    blurRadius: 2,
                                    spreadRadius: 0.3)
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: size.width * 0.3,
                                    height: size.width * 0.3,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: size.width * 0.3,
                                      height: size.width * 0.3,
                                      decoration: const BoxDecoration(),
                                      child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.network(product.image!),
                                              (product.isSoldOut)
                                                  ? Transform.rotate(
                                                angle: pi / 3,
                                                child: const Text(
                                                  "Out Of Stock",
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      color:
                                                      Colors.red),
                                                ),
                                              )
                                                  : Container(),
                                            ],
                                          )),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "${product.name}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        Row(
                                          children: [
                                            const Text("Quantity: ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18)),
                                            GetBuilder<ProductController>(
                                              builder: (controller) => Text(
                                                "${product.quantity}",
                                                style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 16),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        if (product.quantity != 0)
                                          InkWell(
                                            onTap: () {
                                              productController.addToCart(
                                                  i: index);
                                              setState(() {});
                                            },
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10)),
                                              child: const Text("Add To Cart",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              (product.counterStart)
                                  ? Align(
                                alignment: Alignment.topRight,
                                child: Obx(
                                      () => Text(
                                    "${ProductController.counter}",
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                              )
                                  : Container(),
                            ],
                          ),
                        );
                      },
                    ))
              ],
            ),
          ),
        ));
  }
}
