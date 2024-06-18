import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/controller/auth_cubit.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/screens/login_screen.dart';
import 'package:footwear_store_client/core/modules/registration_modules/presentation/screens/register_screen.dart';
import 'package:footwear_store_client/core/utils/styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/modules/home_module/presentation/controller/products_cubit.dart';
import 'core/modules/home_module/presentation/screens/home_screen.dart';
import 'core/modules/registration_modules/presentation/screens/reset_password_screen.dart';
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
// Send OTP
// Add Payment Methods
//Add On Boarding
// Add State Of multiDropDownButton To work Without ALT+S
// Solve Delete Last Item From Admin APP , Floating Action Button Covers Delete Icon

/// Add OoBoarding
/// Add Login , Register Validation
/// Save Token By Shared Pref , Get Storage , Search For Caching Tokens
/// Add Email For Login
/// LogOut From App
/// Record Video For APPS
/// Firebase Login Rules -> Check IF Admin -> Footwear Admin App
///                               IF User -> Footwear Client App

class FootWearStoreClient extends StatelessWidget {
  const FootWearStoreClient({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductsCubit()
            ..fetchAllProducts()
            ..fetchAllProductsCategories(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(FirebaseAuth.instance),
        ),
      ],
      child: MaterialApp(
        title: 'ShoeHub',
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: GoogleFonts.almaraiTextTheme(
            Theme.of(context).textTheme,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),

        ),
        debugShowCheckedModeBanner: false,
        initialRoute:LoginScreen.screenRoute,
        routes: {
          LoginScreen.screenRoute: (context) => LoginScreen(),
          '/reset_password': (context) => ResetPasswordScreen(),
          RegisterScreen.screenRoute: (context) => RegisterScreen(),
          HomeScreen.screenRoute: (context) => HomeScreen(),
        },


      ),
    );
  }
}
