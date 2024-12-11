import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:shoes/pages/client/payment/status/client_payments_status_controller.dart';

import '../../../../src/utils/my_colors.dart';

class ClientPaymentsStatusPage extends StatefulWidget {
  const ClientPaymentsStatusPage({super.key});

  @override
  State<ClientPaymentsStatusPage> createState() => _ClientPaymentsStatusPageState();
}

class _ClientPaymentsStatusPageState extends State<ClientPaymentsStatusPage> {
  final ClientPaymentsStatusController _con = ClientPaymentsStatusController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _clipPathOval(),
          _textCardDetail(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100,
        child: _buttonNext(),
      ),
    );
  }

  Widget _textCardDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Text(
        _con.isPaymentSuccessful
            ? 'Tu orden fue procesada exitosamente con ID de pago: ${_con.paymentId}.'
            : 'Hubo un problema con tu pago. Por favor, inténtalo de nuevo.',
        style: const TextStyle(fontSize: 16),
      ),

    );
  }

  Widget _clipPathOval() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: 250,
        width: double.infinity,
        color: MyColors.primaryDark,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _con.isPaymentSuccessful ? Icons.check_circle : Icons.error,
                color: _con.isPaymentSuccessful ? Colors.green : Colors.red,
                size: 150,
              ),
              Text(
                _con.isPaymentSuccessful
                    ? 'Gracias por su compra'
                    : 'Falló el pago',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _con.finishShopping,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 40.0,
                alignment: Alignment.center,
                child: Text(
                  _con.isPaymentSuccessful ? 'FINALIZAR COMPRA' : 'REINTENTAR PAGO',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: MyColors.cardBgColor,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 50, top: 4),
                height: 30,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: _con.isPaymentSuccessful ? Colors.green : Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
