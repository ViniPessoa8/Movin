import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geopoint/geopoint.dart' as gp;
import 'package:flutter/material.dart';

class Ocorrencia {
  final int idOcorrencia;
  final int idAutor;
  final String descricao;
  final DateTime data;
  final String categoria;
  final gp.GeoPoint local;
  Address endereco;

  Ocorrencia({
    this.idOcorrencia,
    this.endereco,
    @required this.idAutor,
    @required this.descricao,
    @required this.data,
    @required this.categoria,
    @required this.local,
  });
}
