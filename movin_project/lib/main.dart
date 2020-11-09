import 'package:flutter/material.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/view/pages/pagina_login.dart';
import 'package:movin_project/view/pages/pagina_mestre.dart';
import 'package:movin_project/view/pages/pagina_principal.dart';
import 'package:movin_project/view/pages/pagina_selecao_local.dart';
import 'package:movin_project/view/widgets/login/painel_carregamento.dart';
import 'package:movin_project/view/widgets/principal/painel_emergencia.dart';
import 'package:movin_project/view/widgets/login/painel_login.dart';
import 'package:movin_project/view/widgets/principal/painel_config_conta.dart';
import 'package:movin_project/view/widgets/login/painel_cadastro.dart';

final ModelView modelView = ModelView();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MovinApp(modelView));
}

class MovinApp extends StatelessWidget {
  final ModelView mv;

  MovinApp(this.mv);

  @override
  Widget build(BuildContext context) {
    // final PaginaSelecaoArgumentos args =
    //     ModalRoute.of(context).settings.arguments;
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
        PaginaPrincipal.nomeRota: (ctx) => PaginaPrincipal(mv),
        PaginaMestre.nomeRota: (ctx) => PaginaMestre(mv),
        PaginaLogin.nomeRota: (ctx) => PaginaLogin(),
        PainelCarregamento.nomeRota: (ctx) => PainelCarregamento(),
        PainelLogin.nomeRota: (ctx) => PainelLogin(mv),
        PainelCadastro.nomeRota: (ctx) => PainelCadastro(mv),
        PainelConfiguracoesConta.nomeRota: (ctx) =>
            PainelConfiguracoesConta(modelView),
        PainelEmergencia.nomeRota: (ctx) => PainelEmergencia(),
        PaginaSelecaoLocal.nomeRota: (ctx) => PaginaSelecaoLocal(
            mv, mv.enderecoApontadoListenable, mv.paineisPrincipais),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
