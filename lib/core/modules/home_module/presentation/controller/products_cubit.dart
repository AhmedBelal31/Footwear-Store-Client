import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/core/modules/home_module/presentation/controller/products_state.dart';
import '../../../../../const.dart';
import '../../../../services/payment_service.dart';
import '../../data/models/order_product_model.dart';
import '../../data/models/product_category.dart';
import '../../data/models/product_model.dart';

class ProductsCubit extends Cubit<ProductsStates> {
  ProductsCubit() : super(ProductsInitialState());
  String? selectedSort;
  List<ProductModel> products = [];
  List<ProductCategoryOrBrandModel> productsCategories = [];
  List<ProductCategoryOrBrandModel> productsBrands = [];
  List<ProductModel> filteredProducts = [];
  List<String> selectedBrands = [];
  bool isFound = true;
  List<ProductModel> lowPrice = [];
  String selectedCategory = 'ALL';

  // void changeDropDownButtonSort(String? value) {
  //   selectedSort = value;
  //   if (selectedSort == 'Low to High') {
  //     products.sort((a, b) => a.price.compareTo(b.price));
  //   } else {
  //     products.sort((a, b) => b.price.compareTo(a.price));
  //   }
  //
  //   // Update the filtered list based on the sorted main product list
  //   filterProductsByCategory(selectedCategory);
  //
  //   emit(ChangeDropDownBtnSortValueState());
  // }
  void filterProductsByCategory(String category) {
    selectedCategory = category;
    _filterAndSortProducts();
  }

  void filterProductsByBrand(List<String> brands) {
    selectedBrands = brands;
    _filterAndSortProducts();
  }

  void changeSortOrder(String? value) {
    selectedSort = value ?? 'Low to High';
    _filterAndSortProducts();
  }

  void _filterAndSortProducts() {
    filteredProducts.clear();

    for (int i = 0; i < products.length; i++) {
      if ((selectedCategory == 'ALL' ||
              products[i].category == selectedCategory) &&
          (selectedBrands.isEmpty ||
              selectedBrands.contains(products[i].brand))) {
        filteredProducts.add(products[i]);
      }
    }

    if (selectedSort == 'Low to High') {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    }

    if (filteredProducts.isEmpty) {
      isFound = false;
      emit(NoItemsForSelectedCategoryState());
    } else {
      isFound = true;
      emit(GetProductsByCategoryState());
    }
  }

  void fetchAllProducts() {
    emit(GetProductLoadingState());
    FirebaseFirestore.instance
        .collection(kProductsCollection)
        .orderBy('dateTime')
        .get()
        .then((values) {
      products.clear();
      // filteredProducts.clear();
      for (var element in values.docs) {
        print(element.data());

        products.add(ProductModel.fromJson(element.data()));
        // filteredProducts.add(ProductModel.fromJson(element.data()));
      }
      emit(GetProductSuccessState());
    }).catchError((error) {
      print(error.message);
      emit(GetProductFailureState(error: error.toString()));
    });
  }

  void fetchAllProductsCategories() {
    emit(GetProductsCategoriesLoadingState());
    FirebaseFirestore.instance
        .collection(kProductsCategoryCollection)
        .get()
        .then((values) {

          productsCategories.clear();

      for (var element in values.docs) {
        productsCategories.add(ProductCategoryOrBrandModel.fromJson(element.data()));
        print(element.data());
      }
      print('productsCategories $productsCategories');
      emit(GetProductsCategoriesSuccessState());
    }).catchError((error) {
      emit(GetProductsCategoriesFailureState(error: error.toString()));
    });
  }

  void fetchAllProductsBrands() {
    emit(GetProductsBrandLoadingState());
    FirebaseFirestore.instance
        .collection(kProductsBrandsCollection)
        .get()
        .then((values) {
      productsBrands.clear();
      for (var element in values.docs) {
        productsBrands
            .add(ProductCategoryOrBrandModel.fromJson(element.data()));
      }
      // for(int i =0 ; i <productsBrands.length ;i++)
      //   {
      //     print(productsBrands[i].name);
      //   }
      emit(GetProductsBrandSuccessState());
    }).catchError((error) {
      emit(GetProductsBrandFailureState(error: error.toString()));
    });
  }

  // void createPayment({required String currency, required int amount}) async {
  //   StripeService stripeService = StripeService();
  //   emit(StripeLoadingState());
  //   try {
  //     await stripeService.makePayment(
  //       amount: amount,
  //       currency: currency,
  //     );
  //
  //     emit(StripeSuccessState());
  //   } catch (error) {
  //     emit(StripeFailureState(error: error.toString()));
  //   }
  // }
  StripeService stripeService = StripeService();

  Future<void> createPayment({
    required int amount,
    required String currency,
    required OrderProductModel orderProductModel,
  }) async {
    emit(CreateOrderLoadingState());
    // String? customerId = await stripeService.getCustomerId();
    // if (customerId == null) {
    //   emit(CreateOrderFailureState(error: 'Customer ID not found'));
    //   return;
    // }
    try {
      String? transactionId = await stripeService.makePayment(
        amount: amount,
        currency: currency,
      );
      if (transactionId != null) {
        OrderProductModel updatedOrder = orderProductModel.copyWith(
          transactionId: transactionId,
        );
        createOrder(orderProductModel: updatedOrder);
      } else {
        emit(CreateOrderFailureState(error: 'Payment failed'));
      }
    } catch (e) {
      emit(CreateOrderFailureState(error: e.toString()));
    }
  }

  void createOrder({required OrderProductModel orderProductModel}) {
    var ordersDocs = FirebaseFirestore.instance.collection(kProductsOrdersCollection).doc();
      var order =  orderProductModel.copyWith(orderId: ordersDocs.id);
    emit(CreateOrderLoadingState());
    ordersDocs.set(order.toJson()).then((values) {
      emit(CreateOrderSuccessState());
    }).catchError((error) {
      emit(CreateOrderFailureState(error: error.toString()));
    });
  }
}

class OrderFieldsInput {}
