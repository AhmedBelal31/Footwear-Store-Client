
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

 //Get Products Brand
 class GetProductsBrandLoadingState extends ProductsStates {}
 class GetProductsBrandSuccessState extends ProductsStates {}
 class GetProductsBrandFailureState extends ProductsStates {
  final String error;

  GetProductsBrandFailureState({required this.error});
 }

 // Stripe Payment
 class StripeLoadingState extends ProductsStates {}
 class StripeSuccessState extends ProductsStates {}
 class StripeFailureState extends ProductsStates {
  final String error;

  StripeFailureState({required this.error});
 }


 //Create Orders

 class CreateOrderLoadingState extends ProductsStates {}
 class CreateOrderSuccessState extends ProductsStates {}
 class CreateOrderFailureState extends ProductsStates {
  final String error;

  CreateOrderFailureState({required this.error});
 }