import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shoes/pages/roles/roles_controller.dart';
import 'package:shoes/src/models/rol.dart';


class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {

  RolesController _con = new RolesController();
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
        title: Text('Selecciona un rol'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.14),
        child: ListView(
          children: _con.user != null ? _con.user!.roles!.map((Rol rol){
              return _cardRol(rol);
          }).toList():[]
        ),
      )
    );
  }

  Widget _cardRol(Rol rol) {

    return GestureDetector(
      onTap: (){
        _con.goToPage(rol.route!);
      },
      child: Column(
        children: [
          Container(
            height: 100.0,
            child: FadeInImage(
              image: rol.image != null
                  ? NetworkImage(rol.image!) as ImageProvider<Object>
                  : AssetImage('assets/img/no-image.png') as ImageProvider<Object>,

              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ),
          SizedBox(height: 15.0,),
          Text(
              rol.name! ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
          ),
          SizedBox(height: 25.0,),
        ],
      ),
    );
  }

  void refresh(){
    //Is the same is i do ctrl + s
    setState(() {

    });
  }

}
