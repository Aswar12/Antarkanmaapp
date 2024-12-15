// lib/app/bindings/initial_binding.dart

import 'package:antarkanmaapp/app/controllers/homepage_controller.dart';
import 'package:antarkanmaapp/app/controllers/user_main_controller.dart';
import 'package:antarkanmaapp/app/services/product_service.dart';
import 'package:get/get.dart';
import 'package:antarkanmaapp/app/controllers/auth_controller.dart';
import 'package:antarkanmaapp/app/controllers/user_controller.dart';

import 'package:antarkanmaapp/app/services/auth_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put(ProductService(), permanent: true);
    Get.put(AuthService(), permanent: true);
    // Controllers
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => UserController());
    Get.put(UserMainController(), permanent: true);
    Get.lazyPut(() => HomePageController(Get.find<ProductService>()));
  }
}
