import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:footwear_store_client/presentation/controller/products_cubit.dart';
import 'package:footwear_store_client/presentation/screens/home_screen.dart';
import 'package:footwear_store_client/presentation/screens/login_screen.dart';
import 'package:footwear_store_client/presentation/screens/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  runApp(const FootWearStoreClient());
}

// ToDo:
///Cache Products Images
/// Add Payment Methods
/// Add Login , Register Validation
/// Send OTP
/// Logic For Home Screen => Sort , Filter Brand
/// Save Token By Shared Pref , Get Storage , Search For Caching Tokens
/// Add Email For Login
/// LogOut From App
/// Add Offer Percentage To Admin , And Calc Offer Price
/// Add Shimmer Effect For Home Screen
/// Record Video For APPS
/// Solve Delete Last Item From Admin APP , Floating Action Button Covers Delete Icon
/// Firebase Login Rules -> Check IF Admin -> Footwear Admin App
///                               IF User -> Footwear Client App


class FootWearStoreClient extends StatelessWidget {
  const FootWearStoreClient({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit()..fetchAllProducts()..fetchAllProductsCategories(),
      child: MaterialApp(
        title: 'FootWear Store Client',
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.almaraiTextTheme(
            Theme
                .of(context)
                .textTheme,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}


