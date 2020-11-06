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
  // Imagens
  final AssetImage googleLogo = AssetImage('assets/media/google_logo.png');
  final AssetImage facebookLogo = AssetImage('assets/media/facebook_logo.png');
  //Formulário
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmaSenha = TextEditingController();
  // Informação do usuário
  String _nomeUsuario = '';
  String _emailUsuario = '';
  String _senhaUsuario = '';
  bool _pcdUsuario = false;
  bool _termosDeUso = false;

  @override
  void initState() {
    // Adiciona os controladores dos campos do formulário
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // Formulário de Cadastros
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
                          // Nome
                          TextFormField(
                            autofocus: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _controllerNome,
                            validator: (value) {
                              if (value.isEmpty) {
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
                          // Email
                          TextFormField(
                            autofocus: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _controllerEmail,
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
                          // Senha
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _controllerSenha,
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
                          // Confirma senha
                          TextFormField(
                            controller: _controllerConfirmaSenha,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          // Checkbox termos de uso
                          CheckboxListTile(
                            value: _termosDeUso,
                            title: Text('Li e aceito os termos de uso.'),
                            onChanged: (value) {
                              setState(() {
                                _termosDeUso = value;
                              });
                            },
                          ),
                          // Pessoa com deficiência (PCD)
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
                    // Botão 'Cadastrar'
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
            ),
            // Cadastros alternativos
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              height: 200,
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
                      buildCadastroAlternativo(
                        context,
                        'Google  ',
                        googleLogo,
                      ),
                      buildCadastroAlternativo(
                        context,
                        'Facebook',
                        facebookLogo,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* Functions */

  void _tentarCadastro() {
    // Valida o formulário
    final formValido = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (formValido) {
      print('usuario valido');

      // Cadastra o usuário
      Usuario _usuario = Usuario(
        nome: _nomeUsuario,
        email: _emailUsuario,
        pcd: _pcdUsuario,
      );
      _formKey.currentState.save();
      widget.mv.criaUsuario(_usuario, _senhaUsuario);
    }
  }

  /* Builders */

  // Retorna um botão de cadasto alternativo
  Widget buildCadastroAlternativo(
      BuildContext ctx, String titulo, AssetImage imagem) {
    return Container(
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

  // Desaloca componentes
  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    _controllerConfirmaSenha.dispose();
    super.dispose();
  }
}
