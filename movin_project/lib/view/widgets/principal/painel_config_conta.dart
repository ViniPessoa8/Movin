import 'package:flutter/material.dart';

class PainelConfiguracoesConta extends StatelessWidget {
  static String nomeRota = '/perfil/config';

  _buildFlatButton({
    @required BuildContext context,
    @required String titulo,
    @required String dados,
    Function onPressed,
  }) {
    return FlatButton(
      onPressed: () {},
      child: Container(
        width: 400,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titulo,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 25,
                  ),
            ),
            Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 150,
                    ),
                    child: Text(
                      dados,
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações da Conta'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              child: Icon(
                Icons.person,
                size: 100,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                children: [
                  _buildFlatButton(
                    context: context,
                    titulo: 'ID',
                    dados: 'SWEFOMQOM201W',
                  ),
                  _buildFlatButton(
                    context: context,
                    titulo: 'Nome',
                    dados: 'Nome Sobrenome Sobrenome Sobrenome',
                  ),
                  _buildFlatButton(
                    context: context,
                    titulo: 'E-mail',
                    dados: 'emailemail@exemplo.com',
                  ),
                  _buildFlatButton(
                    context: context,
                    titulo: 'Senha',
                    dados: 'Alterar senha',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
