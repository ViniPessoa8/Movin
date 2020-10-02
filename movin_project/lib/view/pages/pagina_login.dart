import 'package:flutter/material.dart';
import 'package:movin_project/view/widgets/painel_boas_vindas.dart';
import 'package:movin_project/view/widgets/painel_cadastro.dart';
import 'package:movin_project/view/widgets/painel_carregamento.dart';
import 'package:movin_project/view/widgets/painel_login.dart';
import 'package:movin_project/model_view/model_view.dart';

void _carregaPainelLogin(BuildContext context) {
  Navigator.of(context).pushNamed(PainelLogin.nomeRota);
}

void _carregaPainelCadastro(BuildContext context) {
  Navigator.of(context).pushNamed(PainelCadastro.nomeRota);
}

class PaginaLogin extends StatelessWidget {
  static final String nomeRota = '/PaginaLogin';

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
