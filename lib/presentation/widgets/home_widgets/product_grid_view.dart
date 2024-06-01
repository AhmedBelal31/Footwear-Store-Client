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
    return BlocConsumer<ProductsCubit, ProductsStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<ProductsCubit>(context);
        if (cubit.products.isEmpty && state is! GetProductLoadingState) {
          return const Center(child: Text('There Is No Products '));
        } else {
          if (state is GetProductFailureState) {
            return Text('Error: ${state.error}');
          } else if (state is GetProductLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppStyles.kPrimaryColor),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                cubit.fetchAllProducts();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return ProductGridViewItem(product: cubit.products[index]);
                  },
                  itemCount: cubit.products.length,
                ),
              ),
            );
          }
        }
      },
    );
  }
}