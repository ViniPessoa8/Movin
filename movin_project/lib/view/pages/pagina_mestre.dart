import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/view/pages/pagina_login.dart';
import 'package:movin_project/view/pages/pagina_principal.dart';
import 'package:movin_project/view/widgets/login/painel_carregamento.dart';
import 'package:scoped_model/scoped_model.dart';

class PaginaMestre extends StatefulWidget {
  static final nomeRota = '/mestre';
  final ModelView mv;

  PaginaMestre(this.mv);

  @override
  _PaginaMestreState createState() => _PaginaMestreState();
}

class _PaginaMestreState extends State<PaginaMestre> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ModelView>(
      model: widget.mv,
      child: ScopedModelDescendant<ModelView>(
        builder: (context, child, model) {
          if (model.dbIniciado) {
            return StreamBuilder(
              // Verifica o estado do usuário (Logado/Deslogado)
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, AsyncSnapshot<User> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    print('ConnectionState.none');
                    break;
                  case ConnectionState.done:
                    print('ConnectionState.done');
                    break;
                  case ConnectionState.waiting:
                    print('ConnectionState.waiting');
                    return PainelCarregamento();
                    break;
                  case ConnectionState.active:
                    print('ConnectionState.active');
                    if (widget.mv.aguardandoResposta) {
                      // Buscando informações do Banco de Dados
                      return PainelCarregamento();
                    } else if (snapshot.hasData) {
                      // Usuario Logado
                      print('LOGADO');
                      print(snapshot.data);

                      widget.mv.setUsuario(snapshot.data.uid);
                      return PaginaPrincipal(widget.mv);
                    } else {
                      // Usuario Deslogado
                      widget.mv.deslogado = true;
                      print('DESLOGADO');
                      return PaginaLogin();
                    }
                    break;
                  default:
                    print('default');
                    return PainelCarregamento();
                    break;
                }
                return PainelCarregamento();
              },
            );
          }
          return PainelCarregamento();
        },
      ),
    );
  }
}
