import 'package:flutter/material.dart';
import 'package:movin_project/view/widgets/login/painel_login.dart';

class PainelBoasVindas extends StatelessWidget {
  static final String nomeRota = '/BoasVindas';
  final Function carregaPainelLogin;
  final Function carregaPainelCadastro;

  PainelBoasVindas(this.carregaPainelLogin, this.carregaPainelCadastro);

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            'Bem-Vindo ao Movin',
            style: Theme.of(context).textTheme.headline5.copyWith(
                  fontSize: 60,
                  color: Theme.of(context).primaryColor,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: double.infinity,
          height: 300,
          child: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
            size: 300,
          ),
        ),
        Column(
          children: [
            Container(
              width: 250,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  'Cadastre-se',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 25, color: Colors.white),
                ),
                onPressed: () => carregaPainelCadastro(context),
              ),
            ),
            FlatButton(
              child: Text(
                'Já possuo uma conta',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 25,
                      color: Theme.of(context).accentColor,
                    ),
              ),
              onPressed: () => carregaPainelLogin(context),
            ),
          ],
        ),
      ],
    );
  }
}
