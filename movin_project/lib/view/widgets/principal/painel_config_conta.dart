import 'package:flutter/material.dart';
import 'package:movin_project/model_view/model_view.dart';

class PainelConfiguracoesConta extends StatefulWidget {
  static String nomeRota = '/perfil/config';
  final ModelView mv;

  PainelConfiguracoesConta(this.mv);

  @override
  _PainelConfiguracoesContaState createState() =>
      _PainelConfiguracoesContaState();
}

class _PainelConfiguracoesContaState extends State<PainelConfiguracoesConta> {
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
                  // Id
                  _buildFlatButton(
                    context: context,
                    titulo: 'ID',
                    dados: widget.mv.usuarioAtual.idUsuario,
                  ),
                  // Nome
                  _buildFlatButton(
                    context: context,
                    titulo: 'Nome',
                    dados: widget.mv.usuarioAtual.nome,
                  ),
                  // Email
                  _buildFlatButton(
                    context: context,
                    titulo: 'E-mail',
                    dados: widget.mv.usuarioAtual.email,
                  ),
                  // Alterar senha
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

  /* Builders */

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
            // Título
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
                    // Dados
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
}
