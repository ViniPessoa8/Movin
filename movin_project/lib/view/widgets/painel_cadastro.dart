import 'package:flutter/material.dart';

class PainelCadastro extends StatelessWidget {
  static final String nomeRota = '/Cadastro';
  final AssetImage googleLogo = AssetImage('assets/media/google_logo.png');
  final AssetImage facebookLogo = AssetImage('assets/media/facebook_logo.png');

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // FORM CADASTRO
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(Icons.image, size: 50),
                //       Text(
                //         'Cadastro',
                //         style: Theme.of(context)
                //             .textTheme
                //             .headline5
                //             .copyWith(fontSize: 30),
                //       ),
                //     ],
                //   ),
                Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Senha'),
                      obscureText: true,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Confirmar Senha'),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: null),
                        Text('Li e aceito os termos de uso.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 17)),
                      ],
                    )
                  ],
                ),
                RaisedButton(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 70),
                    child: Text('Cadastrar'),
                  ),
                  onPressed: () {},
                ),
              ],
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
    );
  }
}
