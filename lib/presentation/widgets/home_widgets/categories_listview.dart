import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/data/models/product_category.dart';
import 'package:footwear_store_client/presentation/controller/products_cubit.dart';

class CategoriesListView extends StatelessWidget {
  final List<ProductCategoryModel> categoryItems;

  const CategoriesListView({super.key, required this.categoryItems});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              BlocProvider.of<ProductsCubit>(context)
                  .filterAllProductsByCategory(categoryItems[index].name);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Chip(
                label: Text(categoryItems[index].name),
              ),
            ),
          );
        },
        itemCount: categoryItems.length,
      ),
    );
  }
}
