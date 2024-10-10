import 'package:flutter/material.dart';


class BusinessOrdersListPage extends StatefulWidget {
  const BusinessOrdersListPage({super.key});

  @override
  State<BusinessOrdersListPage> createState() => _BusinessOrdersListPageState();
}

class _BusinessOrdersListPageState extends State<BusinessOrdersListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Business Orders list'
        ),
      ),
    );
  }
}
