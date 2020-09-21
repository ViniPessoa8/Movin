import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Ocorrencia {
  final int idOcorrencia;
  final int idAutor;
  final String titulo;
  final String descricao;
  final DateTime data;
  final String categoria;
  // final Location local;

  Ocorrencia({
    @required this.idOcorrencia,
    @required this.idAutor,
    @required this.titulo,
    @required this.descricao,
    @required this.data,
    @required this.categoria,
    // @required this.local,
  });
}
