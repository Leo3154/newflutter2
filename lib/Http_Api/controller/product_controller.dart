import 'package:get/get.dart';
import 'package:newflutter2/Http_Api/service/http_service.dart';

class ProductController extends GetxController{
  RxBool isLoading = true.obs;
  var productList = [].obs;

  @override
  void onInit() {
    loadProducts();
    super.onInit();
  }

  void loadProducts() async{
    try{
      isLoading(true);
      var product = await HttpService.fetchProducts();
      if(product != null){
        productList.value = product;
      }
    }
    finally{
      isLoading(false);
    }
  }

}