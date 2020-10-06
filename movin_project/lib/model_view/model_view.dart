import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geopoint/geopoint.dart' as gp;
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart' as mb;
import 'package:scoped_model/scoped_model.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:movin_project/db/firebase_controller.dart';

class ModelView extends Model {
  List<Ocorrencia> ocorrencias;
  gp.GeoPoint localUsuario;
  Address enderecoUsuario;
  FirebaseController _fc;
  bool _dbIniciado;

  ModelView() {
    _usuarioLogado = true;
    indexPainelPrincipal = 1;
    iniciaDb();
    // ocorrencias = [];
  }

  // Firebase

  iniciaDb() async {
    _fc = FirebaseController();
    _dbIniciado = await _fc.inicializaFirestore();
    carregaDados();
  }

  /*** LOGIN ***/
  bool _usuarioLogado;

  get usuarioLogou => _usuarioLogado;
  get carregouOcorrencias => ocorrencias != null;
  get carregouLocalUsuario => localUsuario != null;

  void realizaLogin() {
    _usuarioLogado = true;
    notifyListeners();
  }

  /*** MAIN ***/
  int indexPainelPrincipal;

  get getOcorrencias => ocorrencias;
  get getEndereco => enderecoUsuario;

  void carregaDados() {
    atualizaLocalUsuario();
    atualizaOcorrencias();
  }

  //Atualizadores

  Future<void> atualizaOcorrencias({String bairro}) async {
    print('[DEBUG] atualizaOcorrencias($bairro)');
    if (_dbIniciado) {
      ocorrencias = await _fc.fetchOcorrencias(bairro: bairro);
    } else {
      ocorrencias = [];
    }
    notifyListeners();
  }

  Future<void> atualizaLocalUsuario() async {
    if (_dbIniciado) {
      localUsuario = await _fc.fetchLocalUsuario();
      atualizaEnderecoUsuario();
      notifyListeners();
    }
  }

  Future<void> atualizaEnderecoUsuario() async {
    if (_dbIniciado) {
      enderecoUsuario = await _fc.fetchEndereco(
        localUsuario.latitude,
        localUsuario.longitude,
      );
      notifyListeners();
    }
  }

  void selecionaPagina(int index) {
    indexPainelPrincipal = index;
    notifyListeners();
  }

  // Ocorrencia

  void addOcorrencia(Ocorrencia ocorrencia) async {
    bool resp = await _fc.addOcorrencia(
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

  Future<Address> getEnderecoBD(double latitude, double longitude) async {
    Address result;
    result = await _fc.fetchEndereco(latitude, longitude);
    return result;
  }

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
