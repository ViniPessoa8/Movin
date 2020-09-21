import 'package:flutter/material.dart';

class PainelPerfil extends StatelessWidget {
  Widget _buildBotaoConfig(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      child: FlatButton(
        onPressed: () {},
        child: Column(
          children: [
            Icon(Icons.blur_circular, size: 80),
            Container(
              alignment: Alignment.center,
              width: 150,
              height: 50,
              child: Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
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
                    _buildBotaoConfig(context, 'Configurações da Conta'),
                    _buildBotaoConfig(context, 'Minhas Ocorrências'),
                  ],
                ),
                Column(
                  children: [
                    _buildBotaoConfig(context, 'Rotas Favoritas'),
                    _buildBotaoConfig(context, 'Rotas Utilizadas'),
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
