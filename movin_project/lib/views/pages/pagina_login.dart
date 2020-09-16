import 'package:flutter/material.dart';
import 'package:movin_project/views/widgets/login/painel_boas_vindas.dart';
import 'package:movin_project/views/widgets/login/painel_cadastro.dart';
import 'package:movin_project/views/widgets/login/painel_carregamento.dart';
import 'package:movin_project/views/widgets/login/painel_login.dart';

class PaginaLogin extends StatelessWidget {
  static final String nomeRota = '/PaginaLogin';
  final Function _carregaPainelLogin;
  final Function _carregaPainelCadastro;

  PaginaLogin(this._carregaPainelLogin, this._carregaPainelCadastro);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Movin'),
      ),
      body: PainelBoasVindas(_carregaPainelLogin, _carregaPainelCadastro),
    );
  }
}
