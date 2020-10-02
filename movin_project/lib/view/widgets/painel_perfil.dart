import 'package:flutter/material.dart';
import 'package:movin_project/view/widgets/painel_config_conta.dart';
import 'package:movin_project/view/widgets/painel_cria_ocorrencia.dart';

class PainelPerfil extends StatelessWidget {
  Widget _buildBotaoConfig(
      {@required BuildContext context,
      @required String titulo,
      Function onPressed,
      IconData icone = Icons.settings}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      child: FlatButton(
        onPressed: onPressed,
        child: Column(
          children: [
            Icon(icone, size: 80),
            Container(
              alignment: Alignment.center,
              width: 150,
              height: 50,
              child: Text(
                titulo,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Column(
              children: [
                Icon(
                  Icons.person_pin,
                  size: 120,
                ),
                Text(
                  'Nome',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'Email',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    _buildBotaoConfig(
                        context: context,
                        titulo: 'Configurações da Conta',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(PainelConfiguracoesConta.nomeRota);
                        }),
                    _buildBotaoConfig(
                      context: context,
                      titulo: 'Minhas Ocorrências',
                      icone: Icons.warning,
                    ),
                  ],
                ),
                Column(
                  children: [
                    _buildBotaoConfig(
                      context: context,
                      titulo: 'Rotas Favoritas',
                      icone: Icons.favorite,
                    ),
                    _buildBotaoConfig(
                      context: context,
                      titulo: 'Rotas Utilizadas',
                      icone: Icons.arrow_forward,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
