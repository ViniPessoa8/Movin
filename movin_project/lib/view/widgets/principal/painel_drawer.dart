import 'package:flutter/material.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/view/widgets/principal/painel_emergencia.dart';

class PainelDrawer extends StatelessWidget {
  final ModelView mv;

  PainelDrawer(this.mv);

  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            child: Text(
              'Movin',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          SizedBox(height: 20),
          buildListTile('Home', Icons.home, () {
            Navigator.of(context).pop();
          }),
          buildListTile('Emergência', Icons.settings, () {
            Navigator.of(context).pushNamed(PainelEmergencia.nomeRota);
          }),
          buildListTile('Sair', Icons.chevron_left, () {
            mv.deslogar();
          })
        ],
      ),
    );
  }
}
