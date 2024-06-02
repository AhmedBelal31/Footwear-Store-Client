
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

 //Get Products Categories
 class GetProductsCategoriesLoadingState extends ProductsStates {}
 class GetProductsCategoriesSuccessState extends ProductsStates {}
 class GetProductsCategoriesFailureState extends ProductsStates {
  final String error;

  GetProductsCategoriesFailureState({required this.error});
 }


 //GetProductCategoryByID

 class GetProductsByCategoryState extends ProductsStates {}

 class NoItemsForSelectedCategoryState extends ProductsStates {}
