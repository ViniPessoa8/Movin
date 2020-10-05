import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:movin_project/db/firebase_controller.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:scoped_model/scoped_model.dart';

class ModelView extends Model {
  CollectionReference ocorrenciasBD;
  bool _carregouOcorrencias = false;
  List<Ocorrencia> ocorrencias;
  LocationData localUsuario;
  Address endereco;
  FirebaseController fc;

  /*** FIREBASE ***/

  // Firebase

  iniciaDb() async {
    fc = FirebaseController();
    _dbIniciado = await fc.inicializaFirestore();
    carregaDados();
  }

  void carregaDados() {
    if (_dbIniciado) {
      ocorrenciasBD = FirebaseFirestore.instance.collection('ocorrencias');
      fetchOcorrencias();
      fetchLocalUsuario();
    }
  }

  Future<void> fetchLocalUsuario() async {
    Location().getLocation().then((value) {
      print('[DEBUG fetchLocalUsuario] $value');
      localUsuario = value;
      fetchEndereco();
    });
    notifyListeners();
  }

  Future<void> fetchEndereco() async {
    final coordinates =
        Coordinates(localUsuario.latitude, localUsuario.longitude);
    await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((value) {
      endereco = value.elementAt(0);
    });
    print(
        '${endereco.thoroughfare}, ${endereco.subLocality}. ${endereco.subAdminArea}, ${endereco.adminArea}, ${endereco.countryName}');
    notifyListeners();
  }

  //Atualizadores

  Future<void> atualizaOcorrencias({String bairro}) async {
    print('[DEBUG] atualizaOcorrencias($bairro)');
    if (_dbIniciado) {
      ocorrencias = await fc.fetchOcorrencias(bairro: bairro);
    } else {
      ocorrencias = [];
    }
    notifyListeners();
  }

  Future<void> addOcorrencia({
    @required String descricao,
    @required String categoria,
    DateTime data,
    LocationData local,
    @required int idUsuario,
  }) async {
    if (data == null) data = DateTime.now();
    if (local == null) {
      await Location().getLocation().then((value) => local = value);
    }

    //Conversão de LocationData -> GeoPoint (Firebase)
    GeoPoint geopoint = GeoPoint(local.latitude, local.longitude);

    //Criação da ocorrência no banco de dados
    var id = ocorrenciasBD.add({
      'descicao': descricao,
      'categoria': categoria,
      'data': data,
      'local': geopoint,
      'userId': idUsuario
    });

    print(id);
    notifyListeners();
  }

  escutaOcorrencias() async {
    FirebaseFirestore.instance
        .collection('ocorrencias')
        .snapshots()
        .listen((event) {
      fetchOcorrencias();
    });
  }

  /*** LOGIN ***/

  bool _dbIniciado = false;
  bool _usuarioLogado = true;

  get usuarioLogou => _usuarioLogado;
  get carregouOcorrencias => _carregouOcorrencias;

  void realizaLogin() {
    _usuarioLogado = true;
    notifyListeners();
  }

  // Ocorrencia

  void addOcorrencia(Ocorrencia ocorrencia) async {
    bool resp = await fc.addOcorrencia(
      descricao: ocorrencia.descricao,
      categoria: ocorrencia.categoria,
      data: ocorrencia.data,
      local: ocorrencia.local,
      idUsuario: ocorrencia.idAutor,
    );

    if (resp) {
      print('Ocorrência criada.');
    } else {
      print('Erro na criação da ocorrência.');
    }
  }

  // Endereço

  String formatEndereco(Address endereco) {
    String saida = '';
    if (endereco != null) {
      if (endereco.thoroughfare != null && endereco.subLocality != null) {
        saida += '${endereco.thoroughfare}, ${endereco.subLocality}. ';
      }
      saida += '${endereco.subAdminArea}, ${endereco.adminArea}, ' +
          '${endereco.countryName}';
    }
    return saida;
  }

  // void logaUsuario(BuildContext context) {
  //   print('loga usuario.');
  //   setState(() {
  //     widget.usuarioLogado = true;
  //     Navigator.of(context).pushReplacementNamed(PaginaPrincipal.nomeRota);
  //   });
  // }
}
