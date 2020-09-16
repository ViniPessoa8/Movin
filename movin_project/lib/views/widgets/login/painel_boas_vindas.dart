import 'package:flutter/material.dart';
import 'package:movin_project/views/widgets/login/painel_login.dart';

class PainelBoasVindas extends StatelessWidget {
  static final String nomeRota = '/BoasVindas';
  final Function carregaPainelLogin;

  PainelBoasVindas(this.carregaPainelLogin);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            'Bem-Vindo ao Movin',
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: double.infinity,
          height: 300,
          child: Icon(
            Icons.image,
            size: 300,
          ),
        ),
        Column(
          children: [
            Container(
              width: 200,
              child: RaisedButton(
                child: Text(
                  'Cadastre-se',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 20,
                      ),
                ),
                onPressed: () {},
              ),
            ),
            FlatButton(
              child: Text(
                'Já possuo uma conta',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 20,
                    ),
              ),
              onPressed: () => {carregaPainelLogin(context)},
            ),
          ],
        ),
      ],
    );
  }
}
