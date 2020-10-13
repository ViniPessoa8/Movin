import 'package:flutter/material.dart';

class PainelLogin extends StatefulWidget {
  static final String nomeRota = '/Login';
  final Function _logar;

  PainelLogin(this._logar);

  @override
  _PainelLoginState createState() => _PainelLoginState();
}

class _PainelLoginState extends State<PainelLogin> {
  final AssetImage googleLogo = AssetImage('assets/media/google_logo.png');
  final AssetImage facebookLogo = AssetImage('assets/media/facebook_logo.png');
  final _formKey = GlobalKey<FormState>();
  String _emailUsuario;
  String _senhaUsuario;

  _tentarLogar() {
    final loginValido = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (loginValido) {
      _formKey.currentState.save();
      print(_emailUsuario);
      print(_senhaUsuario);
    }
  }

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
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Email'),
                    onSaved: (newValue) {
                      _emailUsuario = newValue;
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'A senha deve conter ao menos 6 dígitos.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    onSaved: (newValue) {
                      _senhaUsuario = newValue;
                    },
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
                    onPressed: () => _tentarLogar, //widget._logar(context),
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