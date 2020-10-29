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
  bool _deslogado = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ModelView>(
      model: widget.mv,
      child: ScopedModelDescendant<ModelView>(
        builder: (context, child, model) {
          if (model.dbIniciado) {
            // FirebaseAuth.instance.signOut();
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, AsyncSnapshot<User> snapshot) {
                print('[DEBUG] streambuilder');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    print('ConnectionState.waiting');
                    return PainelCarregamento();
                    break;
                  case ConnectionState.active:
                    print('ConnectionState.active');
                    if (widget.mv.aguardandoResposta) {
                      return PainelCarregamento();
                    } else if (snapshot.hasData) {
                      //LOGADO
                      print('LOGADO');
                      print(snapshot.data);
                      if (_deslogado) Navigator.of(context).pop();
                      return PaginaPrincipal(widget.mv);
                    } else {
                      _deslogado = true;
                      print('DESLOGADO');
                      //DESLOGADO
                      return PaginaLogin();
                    }
                    break;
                  case ConnectionState.done:
                    print('ConnectionState.done');
                    break;
                  case ConnectionState.none:
                    print('ConnectionState.none');
                    return PainelCarregamento();
                    break;
                  default:
                    print('default');
                    break;
                }
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
