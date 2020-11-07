import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:movin_project/model_view/model_view.dart';

class PaginaSelecaoArgumentos {
  final ModelView mv;
  final ValueNotifier<Address> enderecoEscolhido;
  final List<Map<String, Object>> paineisPrincipais;

  PaginaSelecaoArgumentos(
      this.mv, this.enderecoEscolhido, this.paineisPrincipais);
}
