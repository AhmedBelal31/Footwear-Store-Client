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
  List<ProductModel> filterProductsByCategory = [];
  bool isFound = true;

  void changeDropDownButtonSort(String? value) {
    selectedSort = value;
    print(selectedSort);
    emit(ChangeDropDownBtnSortValueState());
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



  void filterAllProductsByCategory(String productCategory) {
    filterProductsByCategory.clear();
    for (int i = 0; i < products.length; i++) {
      if (productCategory == 'ALL') {
        if (filterProductsByCategory.length != products.length) {
          filterProductsByCategory.addAll(products);
          print(isFound);
        }
      } else {
        if (products[i].category == productCategory) {
          filterProductsByCategory.add(products[i]);
        }
      }
    }
    if (filterProductsByCategory.isEmpty) {
      isFound = false;
      emit(NoItemsForSelectedCategoryState());
    }
    else
      {
        emit(GetProductsByCategoryState());
      }






  }
}
