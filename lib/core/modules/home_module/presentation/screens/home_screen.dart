// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../registration_modules/presentation/controller/auth_cubit.dart';
// import '../controller/products_cubit.dart';
// import '../controller/products_state.dart';
// import '../widgets/home_widgets/categories_listview.dart';
// import '../widgets/home_widgets/drop_dwon_btn.dart';
// import '../widgets/home_widgets/multi_select_drop_down_btn.dart';
// import '../widgets/home_widgets/product_grid_view.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   static const screenRoute = 'homeScreen';
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     BlocProvider.of<ProductsCubit>(context).fetchAllProductsBrands();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildAppBar(),
//       body: BlocConsumer<ProductsCubit, ProductsStates>(
//         listener: (context, state) {
//           if (state is AuthLoggedOutState) {
//             Navigator.pushReplacementNamed(context, '/login');
//           } else if (state is AuthErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
//           }
//         },
//         builder: (context, state) {
//           var cubit = BlocProvider.of<ProductsCubit>(context);
//           return Column(
//             children: [
//               const SizedBox(height: 10),
//               CategoriesListView(categoryItems: cubit.productsCategories),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: CustomDropDownBtn(
//                       selectedItemText: cubit.selectedSort ?? 'Sort Items',
//                       onValueChanged: (value) {
//                         // cubit.changeDropDownButtonSort(value);
//                         cubit.changeSortOrder(value);
//                       },
//                     ),
//                   ),
//                   const Expanded(
//                     child: MultiSelectDropDownBtn(),
//                   ),
//                 ],
//               ),
//               const Expanded(
//                 child: ProductsGridView(),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   AppBar buildAppBar() {
//     return AppBar(
//       centerTitle: true,
//       title: const Text(
//         'Footwear Store ',
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () {},
//           icon: const Icon(Icons.logout),
//         ),
//         const SizedBox(width: 10),
//       ],
//       scrolledUnderElevation: 0,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/screens/login_screen.dart';
import 'package:footwear_store_client/core/utils/styles.dart';
import '../../../../utils/widgets/awesome_snack_bar.dart';
import '../../../registration_modules/presentation/controller/auth_cubit.dart';
import '../controller/products_cubit.dart';
import '../controller/products_state.dart';
import '../widgets/home_widgets/categories_listview.dart';
import '../widgets/home_widgets/drop_dwon_btn.dart';
import '../widgets/home_widgets/multi_select_drop_down_btn.dart';
import '../widgets/home_widgets/product_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const screenRoute = 'homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductsCubit>(context).fetchAllProductsBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is AuthLoggedOutState) {
            final successSnackBar = customSuccessSnackBar(
              successMessage: 'You have been logged out. Come back soon!',
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(successSnackBar);

            Navigator.pushReplacementNamed(context, LoginScreen.screenRoute);

          }
          else if (state is RegisterWithPhoneNumberFailureState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }

        },
        builder: (context, state) {
          return BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit = BlocProvider.of<ProductsCubit>(context);
              return Column(
                children: [
                  const SizedBox(height: 20),
                  CategoriesListView(categoryItems: cubit.productsCategories),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropDownBtn(
                          selectedItemText: cubit.selectedSort ?? 'Sort Items',
                          onValueChanged: (value) {
                            cubit.changeSortOrder(value);
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
          );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
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
          onPressed: () {
            context.read<AuthCubit>().signOut();
          },
          icon: const Icon(Icons.logout),
        ),
        const SizedBox(width: 10),
      ],
      scrolledUnderElevation: 0,
    );
  }
}
