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

void _carregaPainelLogin(context) {
  print('chamou');
  Navigator.of(context).pushNamed(PainelLogin.nomeRota);
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
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                bodyText2: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                  fontWeight: FontWeight.bold,
                ),
                headline3: TextStyle(
                  fontSize: 55,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.normal,
                ),
                headline6: TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold,
                ),
                headline5: TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.normal,
                ),
              ),
        ),
        initialRoute: usuarioLogado() ? '' : PaginaLogin.nomeRota,
        routes: {
          '/': (ctx) => PaginaPrincipal(),
          PaginaLogin.nomeRota: (ctx) => PaginaLogin(_carregaPainelLogin),
          // PainelBoasVindas.nomeRota: (ctx) => PainelBoasVindas(),
          PainelLogin.nomeRota: (ctx) => PainelLogin(),
          // PainelCadastro.nomeRota: (ctx) => PainelCadastro(),
          // PainelEmergencia.nomeRota: (ctx) => PainelEmergencia(),
        });
  }
}
