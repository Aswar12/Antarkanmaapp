// ignore_for_file: unused_element, avoid_print

import 'package:antarkanmaapp/app/data/models/transaction_model.dart';
import 'package:antarkanmaapp/app/modules/user/views/payment_method_selection_page.dart';
import 'package:antarkanmaapp/app/services/auth_service.dart';
import 'package:antarkanmaapp/app/services/order_item_service.dart';
import 'package:antarkanmaapp/app/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:antarkanmaapp/app/data/models/order_item_model.dart';
import 'package:antarkanmaapp/app/data/models/cart_item_model.dart';
import 'package:antarkanmaapp/app/controllers/cart_controller.dart';
import 'package:antarkanmaapp/app/data/models/user_location_model.dart';
import 'package:antarkanmaapp/app/controllers/auth_controller.dart';
import 'user_location_controller.dart';

class CheckoutController extends GetxController {
  final UserLocationController userLocationController;
  final AuthController authController;

  CheckoutController(
      {required this.userLocationController, required this.authController});

  // Observable properties
  final isLoading = false.obs;
  final orderItems = <OrderItemModel>[].obs;
  final selectedLocation = Rx<UserLocationModel?>(null);
  final selectedPaymentMethod = Rx<String?>(null);
  final subtotal = 0.0.obs;
  final deliveryFee = 0.0.obs;
  final total = 0.0.obs;

  final List<String> paymentMethods = [
    'COD',
    'Transfer Bank',
    'DANA',
    'OVO',
    'GoPay',
  ];

  @override
  void onInit() {
    super.onInit();

    // Prioritaskan lokasi yang dipilih dari UserLocationController
    _initializeCheckoutLocation();

    // Inisialisasi lainnya
    _initializeCheckout();

    // Tambahkan listener untuk perubahan lokasi
    ever(userLocationController.selectedLocation, (location) {
      if (location != null) {
        setDeliveryLocation(location);
      }
    });
  }

  void _initializeCheckoutLocation() {
    // Prioritas:
    // 1. Lokasi yang dipilih di UserLocationController
    // 2. Alamat default
    // 3. Alamat pertama dalam daftar
    final selectedLocation = userLocationController.selectedLocation.value;
    final defaultLocation = userLocationController.defaultAddress;
    final firstLocation = userLocationController.userLocations.isNotEmpty
        ? userLocationController.userLocations.first
        : null;

    UserLocationModel? priorityLocation;

    if (selectedLocation != null) {
      priorityLocation = selectedLocation;
    } else if (defaultLocation != null) {
      priorityLocation = defaultLocation;
    } else if (firstLocation != null) {
      priorityLocation = firstLocation;
    }

    if (priorityLocation != null) {
      // Set lokasi yang dipilih
      this.selectedLocation.value = priorityLocation;

      // Pastikan lokasi juga diset di UserLocationController
      userLocationController.setSelectedLocation(priorityLocation);
    }
  }

  // Method untuk mengupdate lokasi pengiriman
  void setDeliveryLocation(UserLocationModel location) {
    // Update lokasi di CheckoutController
    selectedLocation.value = location;

    // Pastikan lokasi juga diupdate di UserLocationController
    userLocationController.setSelectedLocation(location);

    // Hitung ulang total biaya jika perlu
    _calculateTotals();

    // Perbarui UI
    update();
  }

  // Method untuk memilih lokasi baru
  void updateSelectedLocation(UserLocationModel location) {
    // Gunakan method setDeliveryLocation untuk konsistensi
    setDeliveryLocation(location);
  }

  // Tambahkan method untuk mendapatkan daftar lokasi
  List<UserLocationModel> get availableLocations {
    return userLocationController.userLocations;
  }

  // Method untuk menambah lokasi baru
  Future<bool> addNewLocation(UserLocationModel newLocation) async {
    // Tambah lokasi melalui UserLocationController
    final result = await userLocationController.addAddress(newLocation);

    if (result) {
      // Set lokasi baru sebagai lokasi terpilih
      setDeliveryLocation(newLocation);
    }

    return result;
  }

  // Pastikan method lain yang terkait dengan lokasi tetap konsisten
  bool get canCheckout {
    return selectedLocation.value != null &&
        orderItems.isNotEmpty &&
        selectedPaymentMethod.value != null;
  }

  String? get checkoutBlockReason {
    if (selectedLocation.value == null) {
      return 'Pilih alamat pengiriman';
    }
    // Kondisi lain tetap sama
    return null;
  }

  void _initializeCheckout() {
    try {
      final args = Get.arguments;
      if (args != null && args['merchantItems'] != null) {
        final merchantItems =
            args['merchantItems'] as Map<int, List<CartItemModel>>;

        orderItems.value = merchantItems.entries.expand((entry) {
          return entry.value.map((cartItem) => OrderItemModel(
                orderId: '',
                product: cartItem.product,
                merchant: cartItem.merchant,
                quantity: cartItem.quantity,
                price: cartItem.price,
                selectedVariantId: cartItem.selectedVariantId?.toString(),
                status: 'PENDING',
                createdAt: DateTime.now(),
              ));
        }).toList();

        _calculateTotals();
      }
    } catch (e) {
      _handleInitializationError(e);
    }
  }

  void _handleInitializationError(dynamic error) {
    print('Error initializing checkout: $error');
    Get.snackbar(
      'Error',
      'Terjadi kesalahan saat memuat data checkout',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _calculateTotals() {
    subtotal.value = orderItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    // Perhitungan biaya pengiriman yang lebih fleksibel
    deliveryFee.value = _calculateDeliveryFee();
    total.value = subtotal.value + deliveryFee.value;
  }

  double _calculateDeliveryFee() {
    if (orderItems.isEmpty) return 0.0;

    // Logika perhitungan biaya pengiriman yang lebih kompleks

    // Contoh perhitungan: 10000 untuk berat pertama 1kg, tambahan 5000 per kg
    return 10000.0;
  }

  Future<void> processCheckout() async {
    isLoading.value = true;

    try {
      // Validasi data checkout
      if (!_validateCheckoutData()) {
        return;
      }

      // Buat model transaksi
      final transaction = _createTransactionModel();

      // Simpan transaksi
      final transactionService = Get.find<TransactionService>();
      final createdTransaction =
          await transactionService.createTransaction(transaction);

      if (createdTransaction != null) {
        // Transaksi berhasil dibuat
        _clearCart();
        _navigateToSuccessPage(createdTransaction);
      } else {
        // Gagal membuat transaksi
        _showSnackbar('Error', 'Gagal membuat transaksi');
      }
    } catch (e) {
      _handleCheckoutError(e);
    } finally {
      isLoading.value = false;
    }
  }

  TransactionModel _createTransactionModel() {
    // Pastikan semua data yang diperlukan tersedia
    if (selectedLocation.value == null) {
      throw Exception('Lokasi pengiriman belum dipilih');
    }

    if (selectedPaymentMethod.value == null) {
      throw Exception('Metode pembayaran belum dipilih');
    }

    // Validasi user
    final authService = Get.find<AuthService>();
    final userId = authService.userId;

    if (userId == null) {
      throw Exception('Pengguna tidak terautentikasi');
    }

    // Buat order ID sementara (backend akan mengganti)
    final tempOrderId = DateTime.now().millisecondsSinceEpoch.toString();

    return TransactionModel(
      orderId: tempOrderId,
      userId: userId.toString(),
      userLocationId: selectedLocation.value!.id.toString(),
      totalPrice: subtotal.value,
      shippingPrice: deliveryFee.value,
      paymentMethod: _mapPaymentMethod(selectedPaymentMethod.value!),
      status: 'PENDING',
      paymentStatus: 'PENDING',
    );
  }

  String _mapPaymentMethod(String method) {
    // Sesuaikan metode pembayaran dengan yang diterima backend
    switch (method) {
      case 'COD':
        return 'MANUAL';
      case 'Transfer Bank':
      case 'DANA':
      case 'OVO':
      case 'GoPay':
        return 'ONLINE';
      default:
        return 'MANUAL';
    }
  }

  bool _validateCheckoutData() {
    final validationErrors = <String>[];

    // Validasi items
    if (orderItems.isEmpty) {
      validationErrors.add('Keranjang belanja kosong');
    }

    // Validasi lokasi
    if (selectedLocation.value == null) {
      validationErrors.add('Pilih alamat pengiriman');
    }

    // Validasi metode pembayaran
    if (selectedPaymentMethod.value == null) {
      validationErrors.add('Pilih metode pembayaran');
    }

    // Validasi setiap item
    for (var item in orderItems) {
      if (item.product.id == null) {
        validationErrors.add('Produk tidak valid');
      }
      if (item.merchant.id == null) {
        validationErrors.add('Merchant tidak valid');
      }
      if (item.quantity <= 0) {
        validationErrors.add('Kuantitas produk tidak valid');
      }
    }

    // Validasi user

    // Tampilkan error jika ada
    if (validationErrors.isNotEmpty) {
      _showValidationErrorSnackbar(validationErrors);
      return false;
    }

    return true;
  }

  void _navigateToSuccessPage(TransactionModel transaction) {
    Get.offNamed('/checkout-success', arguments: {
      'transaction': transaction,
      'orderItems': orderItems,
      'total': total.value,
      'deliveryAddress': selectedLocation.value,
    });
  }

  void _handleCheckoutError(dynamic error) {
    print('Checkout error: $error');

    String errorMessage = 'Terjadi kesalahan tidak dikenal';

    if (error is Exception) {
      errorMessage = error.toString();
    } else if (error is String) {
      errorMessage = error;
    }

    Get.snackbar(
      'Error',
      'Gagal memproses checkout: $errorMessage',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  Map<int, List<OrderItemModel>> _groupItemsByMerchant() {
    final Map<int, List<OrderItemModel>> merchantGroups = {};

    for (var item in orderItems) {
      if (item.merchant.id != null) {
        if (!merchantGroups.containsKey(item.merchant.id)) {
          merchantGroups[item.merchant.id!] = [];
        }
        merchantGroups[item.merchant.id!]!.add(item);
      }
    }

    return merchantGroups;
  }

//

  void _showValidationErrorSnackbar(List<String> errors) {
    Get.snackbar(
      'Validasi Gagal',
      errors.join('\n'),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // Method lainnya tetap sama seperti sebelumnya...

  String _getErrorMessage(dynamic error) {
    // Tambahkan logika penanganan error yang lebih spesifik
    if (error is String) return error;
    if (error is Exception) return error.toString();
    return 'Terjadi kesalahan tidak dikenal';
  }

  Future<TransactionModel?> _saveTransaction(
      TransactionModel transaction) async {
    try {
      final transactionService = Get.find<TransactionService>();
      final createdTransaction =
          await transactionService.createTransaction(transaction);

      if (createdTransaction == null) {
        _showSnackbar('Error', 'Gagal membuat transaksi');
        return null;
      }

      return createdTransaction;
    } catch (e) {
      _showSnackbar('Error', 'Gagal menyimpan transaksi: ${e.toString()}');
      return null;
    }
  }

  Future<void> _saveOrderItems(TransactionModel transaction) async {
    final orderItemService = Get.find<OrderItemService>();

    for (var orderItem in orderItems) {
      try {
        // Set order ID dari transaksi yang baru dibuat
        orderItem.orderId =
            transaction.id ?? DateTime.now().millisecondsSinceEpoch.toString();

        final isOrderItemCreated =
            await orderItemService.createOrderItem(orderItem);

        if (!isOrderItemCreated) {
          throw Exception(
              'Gagal menyimpan order item: ${orderItem.product.name}');
        }
      } catch (e) {
        _showSnackbar('Error', 'Gagal menyimpan order item: ${e.toString()}');
        rethrow;
      }
    }
  }

  void _clearCart() {
    try {
      Get.find<CartController>().clearCart();
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  void _showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Colors.white,
    );
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
    update(); // Memperbarui UI jika diperlukan
  }

  void autoSetInitialValues() {
    // Pastikan alamat default sudah diset
    if (selectedLocation.value == null) {
      _initializeCheckoutLocation();
    }

    // Pastikan metode pembayaran sudah diset
    if (selectedPaymentMethod.value == null && paymentMethods.isNotEmpty) {
      setPaymentMethod(paymentMethods.first);
    }

    update();
  }

  void showPaymentMethodModal() async {
    final result = await Get.to(() => const PaymentMethodSelectionPage());

    if (result != null && result is String) {
      setPaymentMethod(result);
    }
  }

  @override
  void onClose() {
    // Clean up jika diperlukan
    super.onClose();
  }
}
