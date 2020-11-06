import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:geopoint/geopoint.dart' as gp;
import 'package:movin_project/model/usuario.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

/*** FIREBASE ***/
class FirebaseController extends Model {
  bool _dbIniciado = false;
  get dbIniciado => _dbIniciado;

  CollectionReference ocorrenciasBD;
  FirebaseFirestore _db;

  Future<bool> inicializaFirestore() async {
    try {
      await Firebase.initializeApp();
      _db = FirebaseFirestore.instance;
      _dbIniciado = true;
      print('Banco de dados carregado.');
      ocorrenciasBD = _db.collection('ocorrencias');
    } catch (e) {
      print('[ERRO]Erro ao carregar Banco de Dados (Firebase): $e');
    }
    return _dbIniciado;
  }

  Future<UserCredential> addUsuarioAuth(String email, String senha) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: senha);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('senha fraca');
      } else if (e.code == 'email-already-in-use') {
        print('A conta já existe para esse e-mail.');
      }
    } catch (e) {
      print('[ERRO] addUsuarioAuth(): $e');
    }
  }

  void addUsuarioBD(String id, Usuario usuario) async {
    if (_dbIniciado) {
      try {
        await _db.collection('usuario').add({
          'id': id,
          'nome': usuario.nome,
          'email': usuario.email,
          'pcd': usuario.pcd,
          'urlFotoPerfil': usuario.urlFotoPerfil,
          // 'idRotasFavoritas' : usuario.idRotasFavoritas,
        });
      } catch (e) {
        print('[ERRO] addUsuarioBD(): $e');
      }
    }
  }

  Future<Usuario> fetchUsuario(String id) async {
    print('[DEBUG] fetchUsuario($id)');
    if (_dbIniciado) {
      try {
        var _usuariosRef = _db.collection('usuario');
        QuerySnapshot _qs = await _usuariosRef.where('id', isEqualTo: id).get();
        var element = _qs.docs.first;
        var _user = element.data();

        Usuario _usuario = Usuario(
          email: _user['email'],
          nome: _user['nome'],
          pcd: _user['pcd'],
          urlFotoPerfil: _user['urlFotoPerfil'],
          idUsuario: _user['id'],
        );

        return _usuario;
      } catch (e) {
        print('[ERRO] fetchUsuario($id): $e');
      }
    }
  }

  Future<gp.GeoPoint> fetchLocalUsuario() async {
    gp.GeoPoint local;
    await Location().getLocation().then((value) {
      print('[DEBUG fetchLocalUsuario] $value');
      local = gp.GeoPoint(latitude: value.latitude, longitude: value.longitude);
    });
    return local;
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
      await _db.collection('ocorrencias').get().then(
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
                idOcorrencia: element.id,
                idUsuario: element.get('idUsuario'),
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
                    print(ocorrencia.categoria);
                    listaOcorrencias.add(ocorrencia);
                  }
                });
              } else {
                print(ocorrencia.categoria);
                listaOcorrencias.add(ocorrencia);
              }
            },
          );
        },
      );
      return listaOcorrencias;
    }
  }

  Future<bool> addOcorrencia({
    @required String descricao,
    @required String categoria,
    @required DateTime data,
    @required gp.GeoPoint local,
    @required String idUsuario,
  }) async {
    GeoPoint localConvertido = GeoPoint(local.latitude, local.longitude);

    //Criação da ocorrência no banco de dados
    var id = await _db.collection('ocorrencias').add({
      'descicao': descricao,
      'categoria': categoria,
      'data': data,
      'local': localConvertido,
      'idUsuario': idUsuario,
    });

    print(id);
    notifyListeners();
    return id != null;
  }

  void deletaTodasOcorrencias() async {
    print('deletaTodasOcorrencias()');
    if (_dbIniciado) {
      try {
        await _db
            .collection('ocorrencias')
            .snapshots()
            .first
            .then((value) => value.docs.forEach((element) {
                  print(element.id);
                  _db.collection('ocorrencias').doc(element.id).delete();
                }));
      } catch (e) {
        print('[ERRO] deletaTodasOcorrencias(): $e');
      }
    }
  }

  void deletaOcorrencia(String id) {}

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
}
