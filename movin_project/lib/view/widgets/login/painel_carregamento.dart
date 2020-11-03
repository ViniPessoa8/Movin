import 'package:flutter/material.dart';

class PainelCarregamento extends StatelessWidget {
  static final String nomeRota = '/carregamento';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movin'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
