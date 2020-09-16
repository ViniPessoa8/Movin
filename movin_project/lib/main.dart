import 'package:flutter/material.dart';
import 'package:movin_project/views/pages/pagina_login.dart';
import 'package:movin_project/views/pages/pagina_principal.dart';
import 'package:movin_project/views/widgets/login/painel_boas_vindas.dart';
import 'package:movin_project/views/widgets/login/painel_cadastro.dart';
import 'package:movin_project/views/widgets/login/painel_login.dart';
import 'package:movin_project/views/widgets/painel_emergencia.dart';

void main() {
  runApp(MyApp());
}

bool usuarioLogado() {
  return false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Movin',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange[600],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: usuarioLogado() ? '/' : PaginaLogin.nomeRota,
        routes: {
          '/': (ctx) => PaginaPrincipal(),
          PaginaLogin.nomeRota: (ctx) => PaginaLogin(),
          // PainelBoasVindas.nomeRota: (ctx) => PainelBoasVindas(),
          // PainelLogin.nomeRota: (ctx) => PainelLogin(),
          // PainelCadastro.nomeRota: (ctx) => PainelCadastro(),
          // PainelEmergencia.nomeRota: (ctx) => PainelEmergencia(),
        });
  }
}
