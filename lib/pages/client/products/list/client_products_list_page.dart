import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:shoes/pages/client/products/list/client_products_list_controller.dart';
import 'package:shoes/src/models/category.dart';
import 'package:shoes/src/models/product.dart';
import 'package:shoes/src/utils/my_colors.dart';

import '../../../../src/widget/no_data_widget.dart';

class ClienteProductsListPage extends StatefulWidget {
  const ClienteProductsListPage({super.key});

  @override
  State<ClienteProductsListPage> createState() =>
      _ClienteProductsListPageState();
}

class _ClienteProductsListPageState extends State<ClienteProductsListPage> {
  ClienteProductsListController _con = new ClienteProductsListController();
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
    return DefaultTabController(
      length: _con.categories!.length,
      child: Scaffold(
          key: _con.key,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(170.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              actions: [
                _shoppingBag(),
              ],
              flexibleSpace: Column(
                children: [
                  SizedBox(
                    height: 40.0,
                  ),
                  _menuDrawer(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _textFieldSearch()
                ],
              ),
              bottom: TabBar(
                indicatorColor: MyColors.primaryDark,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[400],
                isScrollable: true,
                tabs: List<Widget>.generate(_con.categories.length, (index) {
                  return Tab(
                    child: Text(_con.categories[index].name ?? ''),
                  );
                }),
              ),
            ),
          ),
          drawer: _drawer(),
          body: TabBarView(
            children: _con.categories.map((Category category) {
              return FutureBuilder(
                  future: _con.getProducts(category!.id!),
                  builder: (context, AsyncSnapshot<List<Product>>snapshot){

                    if(snapshot.hasData){
                      if(snapshot.data!.length > 0){
                        return GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.6
                            ),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index){
                              return _cardProduct(snapshot.data![index]);
                            }
                        );
                      }
                      else{
                        return NoDataWidget(text: 'No hay productos para esta categoria');
                      }
                    }
                    else{
                      return NoDataWidget(text: 'No hay productos para esta categoria');
                    }


              }
              );
            }).toList(),
          )),
    );
  }

  Widget _cardProduct(Product product) {

    return GestureDetector(
      onTap: (){
        _con.openBottomSheet(product);
      },
      child: Container(
        height: 250.0,
        child: Card(
          color: Colors.white,
            elevation: 3.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
            ),
            child: Stack(

            children: [

              Positioned(
                top: -1.0,
                  right: -1.0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        topRight: Radius.circular(20.0)
                      )
                    ),
                    child: Icon(Icons.add, color: Colors.white,),
                  )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    margin: EdgeInsets.only(top: 43.0),
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: FadeInImage(
                      image: product.image1 != null
                          ? NetworkImage(product!.image1!) as ImageProvider
                          : AssetImage('assets/img/pizza2.png'),
                      fit: BoxFit.fill,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage('assets/img/no-image.png'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    height: 40,
                    child: Text(
                      product.name ?? '',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'NimbusSans'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text('${product.price ?? 0}\$', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, fontFamily: 'NimbusSans'),),
                  )
                ],
              )
            ],
        ),
        ),
      ),
    );
  }

  Widget _textFieldSearch() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Buscar',
            suffixIcon: Icon(
              Icons.search_sharp,
              color: Colors.grey[400],
            ),
            hintStyle: TextStyle(
              fontSize: 17.0,
              color: Colors.grey[500],
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.grey)),
            contentPadding: EdgeInsets.all(15.0)),
      ),
    );
  }

  Widget _shoppingBag() {
    return GestureDetector(
      onTap: _con.goToOrderCreatePage,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15.0),
            child: Icon(
              Icons.shopping_bag_sharp,
              color: Colors.black26,
            ),
          ),
          Positioned(
              right: 16.0,
              child: Container(
                width: 9.0,
                height: 9.0,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
              ))
        ],
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20.0),
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/img/menu.png',
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: MyColors.primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
                Text(
                  _con.user?.email ?? '',
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  maxLines: 1,
                ),
                Text(
                  _con.user?.phone ?? '',
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  maxLines: 1,
                ),
                ClipOval(
                  child: FadeInImage(
                    image: _con.user?.image != null
                        ? NetworkImage(_con.user!.image!)
                            as ImageProvider<Object>
                        : AssetImage('assets/img/no-image.png')
                            as ImageProvider<Object>,
                    placeholder: AssetImage('assets/img/no-image.png'),
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 50),
                    width: 65.0,
                    height: 65.0,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            onTap: _con.goToUpdateProfile,
            title: Text('Editar Perfil'),
            trailing: Icon(Icons.edit),
          ),
          ListTile(
            title: Text('Mis pedidos'),
            trailing: Icon(Icons.shopping_cart),
          ),
          _con.user != null
              ? _con.user!.roles!.length > 1
                  ? ListTile(
                      onTap: _con.goToRoles,
                      title: Text('Seleccionar rol'),
                      trailing: Icon(Icons.person),
                    )
                  : Container()
              : Container(),
          ListTile(
            onTap: _con.logout,
            title: Text('Cerrar sesión'),
            trailing: Icon(Icons.power_settings_new),
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
