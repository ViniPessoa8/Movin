import 'package:flutter/material.dart';
import 'package:movin_project/model/usuario.dart';
import 'package:movin_project/model_view/model_view.dart';

class PainelCadastro extends StatefulWidget {
  static final String nomeRota = '/Cadastro';
  final ModelView mv;

  PainelCadastro(this.mv);

  @override
  _PainelCadastroState createState() => _PainelCadastroState();
}

class _PainelCadastroState extends State<PainelCadastro> {
  final AssetImage googleLogo = AssetImage('assets/media/google_logo.png');
  final AssetImage facebookLogo = AssetImage('assets/media/facebook_logo.png');
  final _formKey = GlobalKey<FormState>();
  String _nomeUsuario = '';
  String _emailUsuario = '';
  String _senhaUsuario = '';
  bool _pcdUsuario = false;
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmaSenha = TextEditingController();
  bool _termosDeUso = false;

  @override
  void initState() {
    _controllerEmail.addListener(() {
      print('Email: ${_controllerEmail.text}');
    });
    _controllerSenha.addListener(() {
      print('Senha: ${_controllerSenha.text}');
    });
    _controllerConfirmaSenha.addListener(() {
      print('Confirma Senha: ${_controllerConfirmaSenha.text}');
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    _controllerConfirmaSenha.dispose();
    super.dispose();
  }

  void _tentarCadastro() {
    final formValido = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (formValido) {
      print('usuario valido');

      Usuario _usuario = Usuario(
        nome: _nomeUsuario,
        email: _emailUsuario,
        pcd: _pcdUsuario,
      );
      _formKey.currentState.save();
      widget.mv.criaUsuario(_usuario, _senhaUsuario);
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
      appBar: AppBar(title: Text('Cadastro')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // FORM CADASTRO
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            autofocus: true,
                            autovalidate: true,
                            controller: _controllerNome,
                            validator: (value) {
                              if (value.isEmpty || value.contains('\d')) {
                                return 'Nome inválido';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Nome'),
                            onChanged: (newValue) {
                              setState(() {
                                _nomeUsuario = newValue;
                              });
                            },
                          ),
                          TextFormField(
                            autofocus: true,
                            autovalidate: true,
                            controller: _controllerEmail,
                            // initialValue: 'vini.pessoa7@gmail.com',
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Email inválido';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Email'),
                            onChanged: (newValue) {
                              setState(() {
                                _emailUsuario = newValue;
                              });
                            },
                          ),
                          TextFormField(
                            autovalidate: true,
                            controller: _controllerSenha,
                            // initialValue: '123456',
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return 'A senha deve conter ao menos 6 dígitos.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Senha'),
                            obscureText: true,
                            onChanged: (newValue) {
                              setState(() {
                                _senhaUsuario = newValue;
                              });
                            },
                          ),
                          TextFormField(
                            controller: _controllerConfirmaSenha,
                            autovalidate: true,
                            // initialValue: '123456',
                            validator: (value) {
                              if (value != _controllerSenha.text) {
                                return 'As senhas devem ser idênticas.';
                              }
                              return null;
                            },
                            decoration:
                                InputDecoration(labelText: 'Confirmar Senha'),
                            obscureText: true,
                            onChanged: (newValue) {
                              setState(() {
                                print("senhas conferem");
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CheckboxListTile(
                            value: _termosDeUso,
                            title: Text('Li e aceito os termos de uso.'),
                            onChanged: (value) {
                              setState(() {
                                _termosDeUso = value;
                              });
                            },
                          ),
                          SwitchListTile(
                            value: _pcdUsuario,
                            title: Text('PCD (Pessoa Com Deficiência)'),
                            onChanged: (value) {
                              setState(() {
                                _pcdUsuario = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 70),
                        child: Text('Cadastrar'),
                      ),
                      onPressed: () {
                        if (_termosDeUso) {
                          _tentarCadastro();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ), // FORM CADASTRO
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              height: 200,
              // CADASTRO ALTERNATIVO
              child: Column(
                children: [
                  Text(
                    'Cadastre-se com',
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
            ), // CADASTRO ALTERNATIVO
          ],
        ),
      ),
    );
  }
}
