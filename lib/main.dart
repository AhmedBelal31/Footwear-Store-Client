import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/modules/home_module/presentation/controller/products_cubit.dart';
import 'core/modules/home_module/presentation/screens/home_screen.dart';
import 'core/services/stripe_keys.dart';
import 'core/utils/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  runApp(const FootWearStoreClient());
}

// ToDo:
//Cache Products Images
// Logic For Home Screen => Sort , Filter Brand
// Add Shimmer Effect For Home Screen

/// Add Payment Methods
/// Add Login , Register Validation
/// Send OTP
/// Save Token By Shared Pref , Get Storage , Search For Caching Tokens
/// Add Email For Login
/// LogOut From App
/// Add Offer Percentage To Admin , And Calc Offer Price
/// Add State Of multiDropDownButton To work Without ALT+S

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
        home: const LoginScreen(),
      ),
    );
  }
}


