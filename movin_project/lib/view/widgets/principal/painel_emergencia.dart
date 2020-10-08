import 'package:flutter/material.dart';

class PainelEmergencia extends StatelessWidget {
  static final String nomeRota = '/emergencias';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Números de Emergência'),
        ),
        body: Center(
          child: Text('Emergências'),
        ));
  }
}
