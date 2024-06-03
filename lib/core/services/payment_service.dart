import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:footwear_store_client/core/services/stripe_keys.dart';
import 'package:http/http.dart' as http;

import '../../data/models/payment/payment_intent_model/payment_intent_model.dart';

class StripeService {
  String stripeBaseUrl = 'https://api.stripe.com/v1';

  ///Get Payment Intent
  Future<PaymentIntentModel> createPaymentIntent(
      {required int amount, required String currency}) async {
    String paymentIntentUrl = '$stripeBaseUrl/payment_intents';
    var response = await http.post(
      Uri.parse(paymentIntentUrl),
      body: {
        'amount': (amount*100).toString(),
        'currency': 'USD',
      },
      headers: {'Authorization': "Bearer $stripeSecretKey"},
    );
    var result = jsonDecode(response.body);

    var paymentIntentModel = PaymentIntentModel.fromJson(result);
    return paymentIntentModel;
  }

  Future<void> initPaymentSheet({ required String paymentIntentClientSecret }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Ahmed Belal',
          paymentIntentClientSecret: paymentIntentClientSecret,
          // Customer keys
          // customerEphemeralKeySecret: data['ephemeralKey'],
          // customerId: data['customer'],
          // Extra options
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
          style: ThemeMode.dark,
        ),
      );

    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
      rethrow;
    }
  }

  Future<void> presentPaymentSheet()async
  {
    await Stripe.instance.presentPaymentSheet();
  }

   Future<void> makePayment({required int amount, required String currency}) async
   {
     var paymentIntentModel = await createPaymentIntent(amount:amount ,currency:currency );
     await  initPaymentSheet(paymentIntentClientSecret: paymentIntentModel.clientSecret!);
     await presentPaymentSheet() ;
   }




}
