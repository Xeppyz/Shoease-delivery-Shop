import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:shoes/pages/client/payment/create/client_payment_create_controller.dart';
import 'package:shoes/src/utils/my_colors.dart';

import '../../../../src/models/user.dart';

/*
class ClientPaymentCreatePage extends StatefulWidget {
  const ClientPaymentCreatePage({super.key});

  @override
  State<ClientPaymentCreatePage> createState() => _ClientPaymentCreatePageState();
}

class _ClientPaymentCreatePageState extends State<ClientPaymentCreatePage> {

  ClientPaymentCreateController _con = new ClientPaymentCreateController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.cardBgLightColor,
        title: Text("Pagos"),
      ),
      body: ListView(
        children: [
          CreditCardWidget(
            cardNumber: _con.cardNumber,
            expiryDate: _con.expiredDate,
            cardHolderName: _con.cardHolderName,
            cvvCode: _con.cvvCode,
            labelCardHolder: 'NOMBRE Y APELLIDO',
            isHolderNameVisible: true,
            cardBgColor: MyColors.cardBgColor,
            showBackView: _con.isCvvFocus,
            obscureCardCvv: true,
            obscureCardNumber: false,//true when you want to show cvv(back) view
            animationDuration: Duration(milliseconds: 1000),
            onCreditCardWidgetChange: (CreditCardBrand brand) {}, // Callback for anytime credit card brand is changed
          ),
          CreditCardForm(
            formKey: _con.keyForm, // Required
            cardNumber: _con.cardNumber, // Required
            expiryDate: _con.expiredDate, // Required
            cardHolderName: _con.cardHolderName, // Required
            cvvCode: _con.cvvCode, // Required
            onCreditCardModelChange: _con.onCreditCardModelChanged, // Required
            obscureCvv: true,
            obscureNumber: true,
            isHolderNameVisible: true,
            isCardNumberVisible: true,
            isExpiryDateVisible: true,
            enableCvv: true,
            cvvValidationMessage: 'Please input a valid CVV',
            dateValidationMessage: 'Please input a valid date',
            numberValidationMessage: 'Please input a valid number',
            cardNumberValidator: (String? cardNumber){},
            expiryDateValidator: (String? expiryDate){},
            cvvValidator: (String? cvv){},
            cardHolderValidator: (String? cardHolderName){},
            onFormComplete: () {
              // callback to execute at the end of filling card data
            },
            autovalidateMode: AutovalidateMode.always,
            disableCardNumberAutoFillHints: false,
            inputConfiguration: const InputConfiguration(
              cardNumberDecoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Numero de la tarjeta',
                hintText: 'XXXX XXXX XXXX XXXX',
              ),
              expiryDateDecoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Fecha de expiración',
                hintText: 'XX/XX',
              ),
              cvvCodeDecoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CVV',
                hintText: 'XXX',
              ),
              cardHolderDecoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre de la tarjeta',
              ),
              cardNumberTextStyle: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
              cardHolderTextStyle: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
              expiryDateTextStyle: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
              cvvCodeTextStyle: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 15,),
          _buttonNext()
        ],
      ),
    );
  }

/*
  Widget  _documentInfo(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Material(
              elevation: 2.0,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Container(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      child: DropdownButton(
                          underline: Container(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_drop_down_circle,
                              color: MyColors.primaryDark,
                            ),
                          ),
                          elevation: 3,
                          isExpanded: true,
                          hint: Text(
                            'C.C',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16

                            ),
                          ),
                          items: _dropDownItems([]),
                          value: '',
                          onChanged: (option){
                            setState(() {
                              print("Repartidor seleccionado: ${option}");
                             // _con.idDelivery = option; // WE'VE PUT THE VALUE SELECTION
                            });
                          }
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 15,),
          Flexible(
            flex: 4,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Numero de documento'
              ),
            ),
          )
        ],
      ),
    );
  }

*/
  Widget _buttonNext(){
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _con.processPayment,
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 40.0,
                alignment: Alignment.center,
                child: Text(
                  'CONTINUAR  ',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: MyColors.cardBgColor
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 3),
                height: 30,
                child: Icon(Icons.arrow_forward_ios, color: Colors.green,),
              ),
            )

          ],
        ),
      ),
    );
  }

  /*
  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user) {
      list.add(DropdownMenuItem(
        value: user.id,
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              child: FadeInImage(
                image: user.image != null
                    ? NetworkImage(user.image!) as ImageProvider
                    : AssetImage('assets/img/no-image.png'),
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            const SizedBox(width: 5),
            Text(user.name!),
          ],
        ),
      ));
    });
    return list;
  }
*/
  void refresh(){
    setState(() {
    });
  }
}
*/