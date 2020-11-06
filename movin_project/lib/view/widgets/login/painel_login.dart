import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movin_project/model_view/model_view.dart';

class PainelLogin extends StatefulWidget {
  static final String nomeRota = '/Login';
  final ModelView mv;

  PainelLogin(this.mv);

  @override
  _PainelLoginState createState() => _PainelLoginState();
}

class _PainelLoginState extends State<PainelLogin> {
  // Imagens
  final AssetImage googleLogo = AssetImage('assets/media/google_logo.png');
  final AssetImage facebookLogo = AssetImage('assets/media/facebook_logo.png');
  // Formulário
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Informações do usuario
  String _emailUsuario;
  String _senhaUsuario;
  // Util
  bool _senhaInvalida = false;
  bool _emailInvalido = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Formulário de Login
              Container(
                child: Form(
                  key: _formKey,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _emailInvalido
                                ? Text('Email não cadastrado.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(color: Colors.red))
                                : _senhaInvalida
                                    ? Text('Senha incorreta',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(color: Colors.red))
                                    : Text(''),
                            FlatButton(
                              onPressed: () {},
                              child: Text(
                                'Esqueceu sua senha?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                            ),
                          ],
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
                        onPressed: _tentarLogar, //widget._logar(context),
                      )
                    ],
                  ),
                ),
              ),
              // Login alternativo
              Container(
                width: double.infinity,
                height: 200,
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
                        buildLoginAlternativo(
                            context, 'Facebook', facebookLogo),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Functions */
  _tentarLogar() async {
    final formLoginValido = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    // Validação do formulário de Login
    if (formLoginValido) {
      var _resposta;
      print('form login válido');
      _formKey.currentState.save();
      print(_emailUsuario);
      print(_senhaUsuario);
      // Realiza o login
      try {
        _resposta = await widget.mv.realizaLogin(
          _emailUsuario,
          _senhaUsuario,
        );
        widget.mv.getUsuarioAtual(); // Carrega informações do usuário que logou
      } on FirebaseAuthException catch (e) {
        // Usuario não encontrado
        if (e.code == 'user-not-found') {
          setState(() {
            _senhaInvalida = false;
            _emailInvalido = true;
          });
          // Senha incorreta
        } else if (e.code == 'wrong-password') {
          setState(() {
            _emailInvalido = false;
            _senhaInvalida = true;
          });
        }
      }
      if (_resposta != null) {
        print(_resposta);
      } else {
        print('LOGIN INVALIDOOO');
      }
    } else {
      print('formulario login invalido');
    }
  }

  /* Builders */
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
}
