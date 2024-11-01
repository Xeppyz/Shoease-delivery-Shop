import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:shoes/pages/client/products/detail/client_products_detail_controller.dart';
import 'package:shoes/src/utils/my_colors.dart';

import '../../../../src/models/product.dart';

class ClientProductsDetailPage extends StatefulWidget {

  Product? product;

  ClientProductsDetailPage({Key? key, @required this.product}) : super(key: key);

  @override
  State<ClientProductsDetailPage> createState() => _ClientProductsDetailPageState();
}

class _ClientProductsDetailPageState extends State<ClientProductsDetailPage> {

  ClientProductsDetailController _con = new ClientProductsDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.product!);
    });
  }

  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          _imageSlideShow(),
          _textName(),
          _textDescription(),
          Spacer(),
          _addOrRemoveItem(),
          _standartDelivery(),
          _buttonShoppingBag()
        ],
      )
    );
  }

  Widget _textName(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),

      child: Text(
        _con.product?.name ?? '',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _textDescription(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),

      child: Text(
        _con.product?.description ?? '',
        style: TextStyle(
            fontSize: 16,
            fontFamily: 'NimbusSans',
            color: Colors.grey
        ),
      ),
    );
  }

  Widget _buttonShoppingBag(){
      return Container(
        margin: EdgeInsets.only(left: 30,right: 30,top: 10),
        child: Column(

          children: [

            Center(

              child: Padding(

                padding: const EdgeInsets.all(20.0),
                child: AddToCartButton(
                  trolley: Image.asset(
                    'assets/img/ic_cart.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                  text: Text(
                    'Añadir producto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  check: SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(24),
                  backgroundColor: MyColors.primaryColor,
                  onPressed: (id) {
                    if (id == AddToCartButtonStateId.idle) {
                      //handle logic when pressed on idle state button.

                      setState(() {
                        stateId = AddToCartButtonStateId.loading;
                        Future.delayed(Duration(seconds: 3), () {
                          setState(() {
                            stateId = AddToCartButtonStateId.done;
                            _con.addToBag();
                          });
                        });
                      });
                    } else if (id == AddToCartButtonStateId.done) {
                      //handle logic when pressed on done state button.
                      _con.close();

                      setState(() {
                        stateId = AddToCartButtonStateId.idle;
                      });
                    }
                  },
                  stateId: stateId,
                ),
              ),
            ),
          ],

        ),
      );
  }

  //WIDGET DEFAULT
  Widget _buttonDefaultBag(){
    return Container(
        margin: EdgeInsets.only(left: 30,right: 30,top: 10),
      child: ElevatedButton(
        onPressed: (){},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50.0,
                alignment: Alignment.center,
                child: Text(
                  'Agregar a la bolsa',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 6),
                height: 30,
                child: Image.asset('assets/img/bag.png'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _standartDelivery(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: [
            Image.asset(
                'assets/img/delivery.png',
              height: 17.0,
            ),
          SizedBox(width: 10.0,),
          Text('Envio estandar', style: TextStyle(fontSize: 12, color: Colors.green),)
        ],
      ),
    );
  }

  Widget _addOrRemoveItem(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 17.0),
      child: Row(
        children: [
          IconButton(
              onPressed: _con.addItem,
              icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey,
                  size: 30.0,
              )
          ),
          Text(
            '${_con.counter}',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey
            ),
          ),
          IconButton(
              onPressed: _con.removeItem,
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.grey,
                size: 30.0,
              )
          ),

          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Text(
              '${_con.productPrice ?? ''}\$',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _imageSlideShow(){
    return Stack(
      children: [
        ImageSlideshow(

          /// Width of the [ImageSlideshow].
          width: double.infinity,

          /// Height of the [ImageSlideshow].
          height: MediaQuery.of(context).size.height * 0.4,

          /// The page to show when first creating the [ImageSlideshow].
          initialPage: 0,

          /// The color to paint the indicator.
          indicatorColor: MyColors.primaryColor,

          /// The color to paint behind th indicator.
          indicatorBackgroundColor: Colors.grey,

          /// Called whenever the page in the center of the viewport changes.
          onPageChanged: (value) {
            print('Page changed: $value');
          },

          /// Auto scroll interval.
          /// Do not auto scroll with null or 0.
          autoPlayInterval: 30000,

          /// Loops back to first slide.
          isLoop: true,

          /// The widgets to display in the [ImageSlideshow].
          /// Add the sample image file into the images folder
          children: [
            FadeInImage(
              image: _con.product != null && _con.product!.image1 != null
                  ? NetworkImage(_con.product!.image1!) as ImageProvider
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.fill,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
            FadeInImage(
              image: _con.product != null && _con.product!.image2 != null
                  ? NetworkImage(_con.product!.image2!) as ImageProvider
                  : AssetImage('assets/img/pizza2.png'),
              fit: BoxFit.fill,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
            FadeInImage(
              image: _con.product != null && _con.product!.image3 != null
                  ? NetworkImage(_con.product!.image3!) as ImageProvider
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.fill,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ],

        ),

        Positioned(
          left: 20.0,
            top: 5.0,
            child: IconButton(
              onPressed: _con.close,
              icon: Icon(Icons.arrow_back_ios, color: MyColors.primaryColor,)
            )
        )
      ],
    );
  }
  void refresh(){
    setState(() {

    });
  }
}
