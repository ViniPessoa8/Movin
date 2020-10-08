import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:geopoint/geopoint.dart' as gp;
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

/*** FIREBASE ***/
class FirebaseController extends Model {
  bool _dbIniciado = false;
  CollectionReference ocorrenciasBD;

  // FirebaseController() {
  //   inicializaFirestore();
  // }

  get dbIniciado => _dbIniciado;

  Future<bool> inicializaFirestore() async {
    try {
      await Firebase.initializeApp();
      _dbIniciado = true;
      // carregaDados();
      // notifyListeners();
      // notifyListeners();
      print('Banco de dados carregado.');
      ocorrenciasBD = FirebaseFirestore.instance.collection('ocorrencias');
      // FirebaseStorage.instance.;
    } catch (e) {
      print('Erro ao carregar Banco de Dados (Firebase):\n$e');
    }
    return _dbIniciado;
  }

  Future<gp.GeoPoint> fetchLocalUsuario() async {
    gp.GeoPoint local;
    await Location().getLocation().then((value) {
      print('[DEBUG fetchLocalUsuario] $value');
      local = gp.GeoPoint(latitude: value.latitude, longitude: value.longitude);
      // fetchEndereco();
    });
    return local;
    // notifyListeners();
  }

  Future<Address> fetchEndereco(double latitude, double longitude) async {
    Address endereco;
    final coordinates = Coordinates(latitude, longitude);
    await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((value) {
      endereco = value.elementAt(0);
    });
    return endereco;
  }

  Future<List<Ocorrencia>> fetchOcorrencias({String bairro}) async {
    List<Ocorrencia> listaOcorrencias = [];
    if (_dbIniciado) {
      await FirebaseFirestore.instance.collection('ocorrencias').get().then(
        (value) {
          value.docs.forEach(
            (element) {
              //Tratamento do elemento
              GeoPoint localBd = element.get('local');
              gp.GeoPoint local = gp.GeoPoint(
                latitude: localBd.latitude,
                longitude: localBd.longitude,
              );

              Ocorrencia ocorrencia = Ocorrencia(
                idOcorrencia: 0,
                idAutor: 0,
                descricao: element.get('descicao'),
                data: element.get('data').toDate(),
                categoria: element.get('categoria'),
                local: local,
                // endereco: value,
              );
              if (bairro != null) {
                fetchEndereco(local.latitude, local.longitude).then((value) {
                  print('SubLocality: ${value.subLocality} | bairro: $bairro');
                  print(
                      'value.subLocality == bairro: ${value.subLocality == bairro}');
                  if (value.subLocality == bairro) {
                    listaOcorrencias.add(ocorrencia);
                    return;
                  }
                });
              } else {
                listaOcorrencias.add(ocorrencia);
              }
            },
          );
        },
      );
    }
    // this.ocorrencias = listaOcorrencias;
    // _carregouOcorrencias = true;
    // notifyListeners();
    return listaOcorrencias;
  }

  Future<bool> addOcorrencia({
    @required String descricao,
    @required String categoria,
    @required DateTime data,
    @required gp.GeoPoint local,
    @required int idUsuario,
  }) async {
    //GeoPoint(GeoPoint) -> GeoPoint(Firebase)
    GeoPoint localConvertido = GeoPoint(local.latitude, local.longitude);

    //Criação da ocorrência no banco de dados
    var id = await ocorrenciasBD.add({
      'descicao': descricao,
      'categoria': categoria,
      'data': data,
      'local': localConvertido,
      'userId': idUsuario,
    });

    print(id);
    return id != null;
    // notifyListeners();
  }

  Future uploadImagem(File imagem) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('imagens/imagem_teste.jpg');
    print('Basename: ${Path.basename(imagem.path)}\n path: ${imagem.path}');
    StorageUploadTask uploadTask = storageReference.putFile(imagem);
    await uploadTask.onComplete;
    print('File Uploaded');
  }

  Future<String> downloadImagemURL() async {
    String imagemURL;

    imagemURL = await FirebaseStorage.instance
        .ref()
        .child('/imagens/imagem_teste.jpg')
        .getDownloadURL();

    print('IMAGEM: $imagemURL');

    return imagemURL;
  }

  // escutaOcorrencias() async {
  //   FirebaseFirestore.instance
  //       .collection('ocorrencias')
  //       .snapshots()
  //       .listen((event) {
  //     fetchOcorrencias();
  //   });
  // }
}
