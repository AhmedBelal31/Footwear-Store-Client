import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/presentation/controller/products_state.dart';
import '../../const.dart';
import '../../data/models/product_category.dart';
import '../../data/models/product_model.dart';

class ProductsCubit extends Cubit<ProductsStates> {
  ProductsCubit() : super(ProductsInitialState());
  String? selectedSort;
  List<ProductModel> products = [];
  List<ProductCategoryModel> productsCategories = [];
  List<ProductModel> filteredProducts = [];
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

  void changeSortOrder(String? value) {
    selectedSort = value ?? 'Low to High';
    _filterAndSortProducts();
  }

  void _filterAndSortProducts() {
    filteredProducts.clear();

    for (int i = 0; i < products.length; i++) {
      if (selectedCategory == 'ALL' || products[i].category == selectedCategory) {
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
      for (var element in values.docs) {
        products.add(ProductModel.fromJson(element.data()));
      }
      emit(GetProductSuccessState());
    }).catchError((error) {
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
        productsCategories.add(ProductCategoryModel.fromJson(element.data()));
      }
      emit(GetProductsCategoriesSuccessState());
    }).catchError((error) {
      emit(GetProductsCategoriesFailureState(error: error.toString()));
    });
  }

  // void filterAllProductsByCategory(String productCategory) {
  //   filterProductsByCategory.clear();
  //   for (int i = 0; i < products.length; i++) {
  //     if (productCategory == 'ALL') {
  //       if (filterProductsByCategory.length != products.length) {
  //         filterProductsByCategory.addAll(products);
  //         print(isFound);
  //       }
  //     } else {
  //       if (products[i].category == productCategory) {
  //         filterProductsByCategory.add(products[i]);
  //       }
  //     }
  //   }
  //   if (filterProductsByCategory.isEmpty) {
  //     isFound = false;
  //     emit(NoItemsForSelectedCategoryState());
  //   } else {
  //     emit(GetProductsByCategoryState());
  //   }
  // }

  // void filterProductsByCategory(String productCategory) {
  //   filteredProducts.clear();
  //   for (int i = 0; i < products.length; i++) {
  //     if (productCategory == 'ALL') {
  //       if (filteredProducts.length != products.length) {
  //         filteredProducts.addAll(products);
  //       }
  //     } else {
  //       if (products[i].category == productCategory) {
  //         filteredProducts.add(products[i]);
  //       }
  //     }
  //   }
  //   if (filteredProducts.isEmpty) {
  //     isFound = false;
  //     emit(NoItemsForSelectedCategoryState());
  //   } else {
  //     emit(GetProductsByCategoryState());
  //   }
  // }
}
