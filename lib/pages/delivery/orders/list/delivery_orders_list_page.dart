import 'package:flutter/material.dart';

class DeliveryOrdersListPage extends StatefulWidget {
  const DeliveryOrdersListPage({super.key});

  @override
  State<DeliveryOrdersListPage> createState() => _DeliveryOrdersListPageState();
}

class _DeliveryOrdersListPageState extends State<DeliveryOrdersListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text(
            'DELIVERY ORDERS LIST'
          ),
        ),
    );
  }
}
