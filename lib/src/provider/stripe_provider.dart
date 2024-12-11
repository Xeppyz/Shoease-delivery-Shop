import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeProvider {
  final String _secretKey =
      'sk_test_51QP9BqFtqesoVyfRlIMvxAoO2vUM9jBrsMcM13NxCcjREByzTKUyBelENNtshFQMpQ6hr8Rpe24J6S7YKSMpj59S00AFElXzSE';
  final String _publishableKey =
      'pk_test_51QP9BqFtqesoVyfRxIPp12Wh6ai1fBOJ86l3JLYyNLefJ0v2ikl2a5Ga9sc8IKlWOP3lOFG4oOYoJ2v96vjo6txI00ZosAZsR0';

  void init() {
    Stripe.publishableKey = _publishableKey;
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  }

  Future<Map<String, dynamic>> _createPaymentIntent(String amount, String currency) async {
    try {
      Uri url = Uri.https('api.stripe.com', 'v1/payment_intents');
      Map<String, String> headers = {
        'Authorization': 'Bearer $_secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al crear PaymentIntent: ${response.body}');
      }
    } catch (e) {
      print('Error al crear PaymentIntent: $e');
      rethrow;
    }
  }

  Future<String> initializePaymentSheet({
    required String amount,
    required String currency,
  }) async {
    try {
      final paymentIntent = await _createPaymentIntent(amount, currency);

      // Guardar el clientSecret y PaymentIntent ID para referencia
      final clientSecret = paymentIntent['client_secret'];
      final paymentIntentId = paymentIntent['id']; // Este es el ID único del pago

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.system,
          merchantDisplayName: 'Your Business Name',
        ),
      );

      return paymentIntentId;
    } catch (e) {
      print('Error al inicializar PaymentSheet: $e');
      rethrow;
    }
  }

  Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print('Pago completado exitosamente');
    } on StripeException catch (e) {
      print('Error al presentar PaymentSheet: ${e.error.localizedMessage}');
      rethrow;
    } catch (e) {
      print('Error inesperado al presentar PaymentSheet: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> retrievePaymentIntent(String paymentIntentId) async {
    try {
      Uri url = Uri.https('api.stripe.com', 'v1/payment_intents/$paymentIntentId');
      Map<String, String> headers = {
        'Authorization': 'Bearer $_secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener el PaymentIntent: ${response.body}');
      }
    } catch (e) {
      print('Error al recuperar el PaymentIntent: $e');
      rethrow;
    }
  }

}
