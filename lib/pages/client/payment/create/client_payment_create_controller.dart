import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:shoes/src/provider/stripe_provider.dart';

/*
class ClientPaymentCreateController{

  BuildContext? context;
  Function? refresh;
  GlobalKey<FormState> keyForm = new GlobalKey();

  String cardNumber = '';
  String expiredDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocus = false;

  StripeProvider? _stripeProvider = StripeProvider();

  Future? init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;

    _stripeProvider?.init();
    return null;


  }
  void onCreditCardModelChanged(CreditCardModel creditCardModel) {
    cardNumber = creditCardModel.cardNumber;
    expiredDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocus = creditCardModel.isCvvFocused;
    refresh!();
  }

  Future<void> processPayment() async {
    if (cardNumber.isEmpty || expiredDate.isEmpty || cardHolderName.isEmpty || cvvCode.isEmpty) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos de la tarjeta')),
      );
      return;
    }

    if (!keyForm.currentState!.validate()) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    // Intentar procesar el pago
    try {
      // Monto de ejemplo (5000 centavos = $50.00 USD)
      final String amount = '5000';
      final String currency = 'usd';


      final response = await _stripeProvider?.payWithCard(
        cardNumber: cardNumber,
        expiryDate: expiredDate,
        cardHolderName: cardHolderName,
        cvvCode: cvvCode,
        amount: amount,
        currency: currency,
      );

      if (response!.success!) {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(content: Text('Pago exitoso: ${response.message}')),
        );
      } else {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(content: Text('Pago fallido: ${response.message}')),
        );
      }
    } catch (e) {
      print('Error en el proceso de pago: $e');
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(content: Text('Error al procesar el pago')),
      );
    }
  }



}


 */