import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Rota {
  final int idRota;
  final Location localInicial;
  final Location localFinal;
  final List<Location> pontosIntermediarios;

  Rota({
    @required this.idRota,
    @required this.localInicial,
    @required this.localFinal,
    @required this.pontosIntermediarios,
  });
}
