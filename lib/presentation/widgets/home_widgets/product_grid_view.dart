import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/styles.dart';
import '../../controller/products_cubit.dart';
import '../../controller/products_state.dart';
import 'product_gridview_item.dart';

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return BlocConsumer<ProductsCubit, ProductsStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<ProductsCubit>(context);
        // if (cubit.products.isEmpty && state is! GetProductLoadingState)
        ///TO DO :
        if (2 > 3) {
          return const Center(child: Text('There Is No Products '));
        } else {
          if (state is GetProductFailureState) {
            return Text('Error: ${state.error}');
          } else if (state is GetProductLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppStyles.kPrimaryColor),
            );
          } else {
            if (state is NoItemsForSelectedCategoryState) {
              return const Center(
                child: Text(
                  'No Items for this Category 😟',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                cubit.fetchAllProducts();
              },
              child: Container(
                color: Colors.grey[300],
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // childAspectRatio:.8,
                    childAspectRatio: screenWidth / screenHeight * 1.58,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                  ),
                  itemBuilder: (context, index) {
                    return ProductGridViewItem(
                        product: cubit.filteredProducts.isEmpty &&
                                cubit.isFound == true
                            ? cubit.products[index]
                            : cubit.filteredProducts[index]);
                  },
                  itemCount: cubit.filteredProducts.isEmpty &&
                          cubit.isFound == true
                      ? cubit.products.length
                      : cubit.filteredProducts.length,
                ),
              ),
            );
          }
        }
      },
    );
  }
}
