import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:footwear_store_client/core/services/stripe_keys.dart';
import 'package:http/http.dart' as http;

import '../modules/home_module/data/models/payment/ephemeral_key_model/ephemeral_key_model.dart';
import '../modules/home_module/data/models/payment/payment_intent_model/payment_intent_model.dart';


class StripeService {
  String stripeBaseUrl = 'https://api.stripe.com/v1';
  String stripeEphemeralKeyUrl = 'https://api.stripe.com/v1/ephemeral_keys';

  Future<String> createCustomer() async {
    var response = await http.post(
      Uri.parse('$stripeBaseUrl/customers'),
      headers: {
        'Authorization': "Bearer $stripeSecretKey",
      },
    );
    var result = jsonDecode(response.body);
    return result['id'];
  }


  ///Get Payment Intent
  Future<PaymentIntentModel> createPaymentIntent(
      {required int amount, required String currency}) async {
    String paymentIntentUrl = '$stripeBaseUrl/payment_intents';
    var response = await http.post(
      Uri.parse(paymentIntentUrl),
      body: {
        'amount': (amount * 100).toString(),
        'currency': 'USD',
        'customer': customerId,
      },
      headers: {'Authorization': "Bearer $stripeSecretKey"},
    );
    var result = jsonDecode(response.body);

    var paymentIntentModel = PaymentIntentModel.fromJson(result);
    return paymentIntentModel;
  }

  Future<void> initPaymentSheet(
      {required String paymentIntentClientSecret,
      required String customerEphemeralKeySecret}) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Ahmed Belal',
          paymentIntentClientSecret: paymentIntentClientSecret,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
          customerId: customerId,
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

  Future<void> presentPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future<EphemeralKeyModel> createEphemeralKey({
    required String customerId,
  }) async {
    var response = await http.post(
      Uri.parse(stripeEphemeralKeyUrl),
      body: {'customer': customerId},
      headers: {
        'Authorization': "Bearer $stripeSecretKey",
        'Stripe-Version': '2023-10-16',
      },
    );
    var result = jsonDecode(response.body);

    var ephemeralKeyModel = EphemeralKeyModel.fromJson(result);
    return ephemeralKeyModel;
  }
  //
  // Future<void> makePayment(
  //     {required int amount, required String currency}) async {
  //   var paymentIntentModel =
  //       await createPaymentIntent(amount: amount, currency: currency);
  //    var ephemeralKeyModel =await createEphemeralKey(customerId: customerId);
  //   await initPaymentSheet(
  //     paymentIntentClientSecret: paymentIntentModel.clientSecret!,
  //     customerEphemeralKeySecret: ephemeralKeyModel.secret! ,
  //   );
  //   await presentPaymentSheet();
  // }
  Future<String?> makePayment({
    required int amount,
    required String currency,
  }) async {
    var paymentIntentModel = await createPaymentIntent(
      amount: amount,
      currency: currency,

    );
    var ephemeralKeyModel = await createEphemeralKey(customerId: customerId);
    await initPaymentSheet(
      paymentIntentClientSecret: paymentIntentModel.clientSecret!,
      customerEphemeralKeySecret: ephemeralKeyModel.secret!,

    );
    await presentPaymentSheet();
    // Return transaction ID
    return paymentIntentModel.id;
  }

}


