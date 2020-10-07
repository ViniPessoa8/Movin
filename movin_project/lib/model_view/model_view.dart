import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geopoint/geopoint.dart' as gp;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

  List<File> imagens = [];
  ImagePicker _imgPicker = new ImagePicker();

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

  String formatEndereco(Address endereco) {
    String saida = '';
    print('endereço: $endereco');
    if (endereco != null) {
      if (endereco.thoroughfare != null && endereco.subLocality != null) {
        saida += '${endereco.thoroughfare}, ${endereco.subLocality}. ';
      }
      saida += '${endereco.subAdminArea}, ${endereco.adminArea}, ' +
          '${endereco.countryName}';
    }
    return saida;
  }

  String formatData(DateTime data) {
    final DateFormat formatadorData = DateFormat('dd/MM/yyyy\nHH:mm');
    return formatadorData.format(data);
  }

  void uploadImagem(File imagem) {
    _fc.uploadFile(imagem);
  }

  imgCamera() async {
    PickedFile img = await _imgPicker.getImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    print('Imagem selecionada: ${img.path}');

    imagens.add(File(img.path));
    notifyListeners();
  }

  imgGaleria() async {
    PickedFile img = await _imgPicker.getImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    print('Imagem selecionada: ${img.path}');

    imagens.add(File(img.path));
    notifyListeners();
  }

  // Endereço

  Future<Address> getEnderecoBD(double latitude, double longitude) async {
    Address result;
    result = await _fc.fetchEndereco(latitude, longitude);
    return result;
  }

  // void logaUsuario(BuildContext context) {
  //   print('loga usuario.');
  //   setState(() {
  //     widget.usuarioLogado = true;
  //     Navigator.of(context).pushReplacementNamed(PaginaPrincipal.nomeRota);
  //   });
  // }
}
