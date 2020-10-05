import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:scoped_model/scoped_model.dart';

class ModelView extends Model {
  CollectionReference ocorrenciasBD;
  bool _carregouOcorrencias = false;
  List<Ocorrencia> ocorrencias;
  LocationData localUsuario;
  Address endereco;

  /*** FIREBASE ***/

  Future<void> inicializaFirestore() async {
    try {
      await Firebase.initializeApp();
      _dbIniciado = true;
      carregaDados();
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar Banco de Dados (Firebase):\n$e');
    }
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

  Future<void> fetchOcorrencias({String filtro}) async {
    List<Ocorrencia> listaOcorrencias = [];
    if (_dbIniciado) {
      await FirebaseFirestore.instance.collection('ocorrencias').get().then(
        (value) {
          value.docs.forEach(
            (element) {
              Ocorrencia ocorrencia = Ocorrencia(
                idOcorrencia: 0,
                idAutor: 0,
                descricao: element.get('descicao'),
                data: element.get('data').toDate(),
                categoria: element.get('categoria'),
                local: element.get('local'),
              );
              listaOcorrencias.add(ocorrencia);
            },
          );
        },
      );
    }
    this.ocorrencias = listaOcorrencias;
    _carregouOcorrencias = true;
    notifyListeners();
  }

  Future<void> addOcorrencia(
      {@required String descricao,
      @required String categoria,
      DateTime data,
      LocationData local,
      @required int idUsuario}) async {
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

  /*** MAIN ***/
  int indexPainelPrincipal = 1;

  get getOcorrencias => ocorrencias;
  get getEnderesso => endereco;

  void selecionaPagina(int index) {
    indexPainelPrincipal = index;
    notifyListeners();
  }

  // Endereço
  String formatEndereco(Address endereco) {
    if (endereco != null)
      return '${endereco.thoroughfare}, ${endereco.subLocality}. ${endereco.subAdminArea}, ${endereco.adminArea}, ${endereco.countryName}';
  }

  // void logaUsuario(BuildContext context) {
  //   print('loga usuario.');
  //   setState(() {
  //     widget.usuarioLogado = true;
  //     Navigator.of(context).pushReplacementNamed(PaginaPrincipal.nomeRota);
  //   });
  // }
}
