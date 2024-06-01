import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/presentation/controller/products_cubit.dart';
import 'package:footwear_store_client/presentation/controller/products_state.dart';
import '../widgets/home_widgets/categories_listview.dart';
import '../widgets/home_widgets/drop_dwon_btn.dart';
import '../widgets/home_widgets/multi_select_drop_down_btn.dart';
import '../widgets/home_widgets/product_grid_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: BlocConsumer<ProductsCubit, ProductsStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = BlocProvider.of<ProductsCubit>(context);
          return Column(
            children: [
              const SizedBox(height: 10),
              const CategoriesListView(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomDropDownBtn(
                      selectedItemText: cubit.selectedSort ?? 'Sort Items',
                      onValueChanged: (value) {
                        cubit.changeDropDownButtonSort(value);
                      },
                    ),
                  ),
                  const Expanded(
                    child: MultiSelectDropDownBtn(),
                  ),
                ],
              ),
              const Expanded(
                child: ProductsGridView(),
              ),
            ],
          );
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Footwear Store ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.logout),
        ),
        const SizedBox(width: 10),
      ],
      scrolledUnderElevation: 0,
    );
  }
}




