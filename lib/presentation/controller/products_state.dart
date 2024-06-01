
 class ProductsStates {}

 class ProductsInitialState extends ProductsStates {}

 class ChangeDropDownBtnSortValueState extends ProductsStates {}

 //Get Products
 class GetProductLoadingState extends ProductsStates {}
 class GetProductSuccessState extends ProductsStates {}
 class GetProductFailureState extends ProductsStates {
  final String error;

  GetProductFailureState({required this.error});
 }
