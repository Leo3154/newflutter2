import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newflutter2/Http_Api/controller/product_controller.dart';
import 'package:newflutter2/Http_Api/widgets/ProductCustomWidget.dart';

void main(){
  runApp(GetMaterialApp(home: HttpHome(),
  useInheritedMediaQuery: true,
  debugShowCheckedModeBanner: false,
  ));
}

class HttpHome extends StatelessWidget{
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product"),
      actions: const [
        Icon(Icons.shopping_cart),
      ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text("Shop Now",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
          Expanded(child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(),);
            } else {
              return GridView.builder(
                itemCount: controller.productList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ), itemBuilder: (context, index) {
                  return ProductCustom(controller.productList[index]);
              });
            }
          }))
        ],
      ),

    );
  }
}