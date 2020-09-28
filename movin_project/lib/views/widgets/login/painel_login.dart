import 'package:flutter/material.dart';

class PainelLogin extends StatelessWidget {
  static final String nomeRota = '/Login';
  final Function _logar;
  final AssetImage googleLogo = AssetImage('assets/media/google_logo.png');
  final AssetImage facebookLogo = AssetImage('assets/media/facebook_logo.png');

  PainelLogin(this._logar);

  Widget buildLoginAlternativo(
      BuildContext ctx, String titulo, AssetImage imagem) {
    return Container(
      // decoration: BoxDecoration(border: Border.all()),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Image(
              image: imagem,
              width: 30,
            ),
          ),
          Text(
            titulo,
            style: Theme.of(ctx).textTheme.headline6,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // FORMULARIO LOGIN
            Container(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Esqueceu sua senha?',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 16,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RaisedButton(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Text('Login'),
                    ),
                    onPressed: () => _logar(context),
                  )
                ],
              ),
            ), // FORMULARIO LOGIN
            Container(
              width: double.infinity,
              height: 200,
              // LOGIN ALTERNATIVO
              child: Column(
                children: [
                  Text(
                    'Logar com',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 20,
                        ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildLoginAlternativo(context, 'Google  ', googleLogo),
                      buildLoginAlternativo(context, 'Facebook', facebookLogo),
                    ],
                  ),
                ],
              ),
            ), // LOGIN ALTERNATIVO
          ],
        ),
      ),
    );
  }
}
