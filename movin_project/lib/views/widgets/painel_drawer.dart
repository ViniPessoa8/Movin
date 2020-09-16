import 'package:flutter/material.dart';
import 'package:movin_project/views/widgets/painel_emergencia.dart';

class PainelDrawer extends StatelessWidget {
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
          buildListTile('Home', Icons.restaurant, () {
            Navigator.of(context).pushReplacementNamed('/');
          }),
          buildListTile('Emergência', Icons.settings, () {
            Navigator.of(context).pushNamed(PainelEmergencia.nomeRota);
          }),
        ],
      ),
    );
  }
}