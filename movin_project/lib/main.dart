import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/view/pages/pagina_login.dart';
import 'package:movin_project/view/pages/pagina_mestre.dart';
import 'package:movin_project/view/pages/pagina_principal.dart';
import 'package:movin_project/view/widgets/principal/painel_emergencia.dart';
import 'package:movin_project/view/widgets/login/painel_login.dart';
import 'package:movin_project/view/widgets/principal/painel_config_conta.dart';
import 'package:movin_project/view/widgets/login/painel_cadastro.dart';

final ModelView modelView = ModelView();

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // escutaLogin();
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
      initialRoute: PaginaMestre.nomeRota,
      routes: {
        PaginaPrincipal.nomeRota: (ctx) => PaginaPrincipal(modelView),
        PaginaMestre.nomeRota: (ctx) => PaginaMestre(modelView),
        // PaginaLogin.nomeRota: (ctx) => PaginaLogin(),
        // PainelBoasVindas.nomeRota: (ctx) => PainelBoasVindas(),
        PainelLogin.nomeRota: (ctx) => PainelLogin(modelView),
        PainelCadastro.nomeRota: (ctx) => PainelCadastro(modelView),
        PainelConfiguracoesConta.nomeRota: (ctx) =>
            PainelConfiguracoesConta(modelView),
        PainelEmergencia.nomeRota: (ctx) => PainelEmergencia(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
