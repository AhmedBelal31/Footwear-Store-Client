import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:footwear_store_client/presentation/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FootWearStoreClient());
}

class FootWearStoreClient extends StatelessWidget {
  const FootWearStoreClient({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FootWear Store Client',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.almaraiTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Colors.white ,
        appBarTheme:const  AppBarTheme(
            backgroundColor: Colors.white
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}


