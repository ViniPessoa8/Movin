import 'package:flutter/material.dart';

class PainelLogin extends StatelessWidget {
  static final String nomeRota = '/Login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(child: Text('Login')),
    );
  }
}
