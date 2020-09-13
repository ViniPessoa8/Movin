import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Zona {
  final int idZona;
  final List<Location> area;
  bool risco;
  String descricaoRisco;

  Zona({
    @required this.idZona,
    @required this.area,
    this.risco,
    this.descricaoRisco,
  });
}
