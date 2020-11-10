import 'package:flutter/material.dart';

class PainelBoasVindas extends StatelessWidget {
  static final String nomeRota = '/BoasVindas';
  final Function _carregaPainelLogin;
  final Function _carregaPainelCadastro;

  PainelBoasVindas(this._carregaPainelLogin, this._carregaPainelCadastro);

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
                onPressed: () => _carregaPainelCadastro(context),
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
              onPressed: () => _carregaPainelLogin(context),
            ),
          ],
        ),
      ],
    );
  }
}
