import 'package:flutter/material.dart';

class PainelCadastro extends StatelessWidget {
  static final String nomeRota = '/Cadastro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: Center(
        child: Text('Painel Cadastro'),
      ),
    );
  }
}
