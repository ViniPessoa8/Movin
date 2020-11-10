import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:movin_project/model_view/model_view.dart';

class SelecaoLocalBox extends StatelessWidget {
  final ValueListenable _enderecoApontado;
  final ModelView _mv;

  SelecaoLocalBox(this._enderecoApontado, this._mv);

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
              if (value != null && _mv.enderecoApontado != null) {
                return Text('${_mv.formatEndereco(value)}');
              }
              return Text('(Carregando)');
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Cancelar')),
              RaisedButton(
                onPressed: () {
                  print(
                      '[DEBUG] mv.escolhendoLocalOcorrencia = ${_mv.escolhendoLocalOcorrencia}');
                  _mv.enderecoApontado = _enderecoApontado.value;
                  _mv.updateLocalApontado(LatLng(
                      _mv.enderecoApontado.coordinates.latitude,
                      _mv.enderecoApontado.coordinates.longitude));
                  print('${_mv.enderecoApontado.addressLine}');
                  print('${_mv.localApontado.toString()}');
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Aceitar'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
