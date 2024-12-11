import 'package:flutter/material.dart';

class ClientPaymentsStatusController {
  late BuildContext context;
  late Function refresh;

  bool isPaymentSuccessful = false; // Indica si el pago fue exitoso
  String paymentId = ''; // ID del pago de Stripe
  String cardLast4 = ''; // ID del pago de Stripe
  String brand = ''; // ID del pago de Stripe

  void init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is Map<String, dynamic>) {
      isPaymentSuccessful = arguments['success'] ?? false;
      paymentId = arguments['paymentId'] ?? '';
      cardLast4 = arguments['cardLast4'] ?? '';
      brand = arguments['brand'] ?? '';
    } else {
      isPaymentSuccessful = false;
      paymentId = '';
      cardLast4 = '';
      brand = '';
    }

    refresh();
  }


  void finishShopping() {
    if (isPaymentSuccessful) {
      Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
    } else {
      Navigator.pop(context); // Vuelve para intentar el pago de nuevo
    }
  }
}
