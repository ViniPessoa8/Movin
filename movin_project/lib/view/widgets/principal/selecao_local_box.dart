import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:movin_project/model_view/model_view.dart';

class SelecaoLocalBox extends StatelessWidget {
  final ValueListenable _enderecoApontado;
  final ModelView mv;

  SelecaoLocalBox(this._enderecoApontado, this.mv);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ValueListenableBuilder<Address>(
            valueListenable: _enderecoApontado,
            child: Text('(Carregando...)'),
            builder: (context, value, child) {
              print('[DEBUG] ValueListenableBuilder');
              if (value != null && mv.enderecoApontado != null) {
                return Text('${mv.formatEndereco(value)}');
              }
              return Text('(Carregando)');
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(onPressed: mv.mudaModo, child: Text('Cancelar')),
              RaisedButton(
                onPressed: () => print('aceitar'),
                child: Text('Aceitar'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
