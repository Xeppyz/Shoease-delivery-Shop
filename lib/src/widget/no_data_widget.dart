import 'package:flutter/material.dart';


class NoDataWidget extends StatelessWidget {

  String text;

  NoDataWidget({Key? key, required this.text}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 50.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/no_items.png'),
            Text(text)
          ],
        ),
      ),
    );
  }
}
