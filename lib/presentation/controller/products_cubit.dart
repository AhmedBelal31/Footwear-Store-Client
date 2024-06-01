import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/presentation/controller/products_state.dart';
import '../../const.dart';
import '../../data/models/product_model.dart';
class ProductsCubit extends Cubit<ProductsStates> {
  ProductsCubit() : super(ProductsInitialState());
  String? selectedSort;
  List<ProductModel> products = [];
  void changeDropDownButtonSort(String? value) {
    selectedSort = value;
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

}
