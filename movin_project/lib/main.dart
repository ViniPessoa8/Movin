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

void _carregaPainelLogin(BuildContext context) {
  Navigator.of(context).pushNamed(PainelLogin.nomeRota);
}

void _carregaPainelCadastro(BuildContext context) {
  Navigator.of(context).pushNamed(PainelCadastro.nomeRota);
}

class MyApp extends StatefulWidget {
  bool usuarioLogado = false;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool usuarioLogou() {
    return widget.usuarioLogado;
  }

  void logaUsuario(BuildContext context) {
    print('loga usuario.');
    setState(() {
      widget.usuarioLogado = true;
      Navigator.of(context).pushReplacementNamed(PaginaPrincipal.nomeRota);
    });
  }

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
        initialRoute:
            usuarioLogou() ? PaginaPrincipal.nomeRota : PaginaLogin.nomeRota,
        routes: {
          PaginaPrincipal.nomeRota: (ctx) => PaginaPrincipal(),
          PaginaLogin.nomeRota: (ctx) =>
              PaginaLogin(_carregaPainelLogin, _carregaPainelCadastro),
          // PainelBoasVindas.nomeRota: (ctx) => PainelBoasVindas(),
          PainelLogin.nomeRota: (ctx) => PainelLogin(logaUsuario),
          PainelCadastro.nomeRota: (ctx) => PainelCadastro(),
          // PainelEmergencia.nomeRota: (ctx) => PainelEmergencia(),
        });
  }
}
