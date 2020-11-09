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
      QuerySnapshot _qs = await _db.collection('ocorrencias').get();

      for (QueryDocumentSnapshot doc in _qs.docs) {
        // Tratamento do elemento
        GeoPoint localBd = doc.get('local');
        gp.GeoPoint local = gp.GeoPoint(
          latitude: localBd.latitude,
          longitude: localBd.longitude,
        );

        Address _endereco =
            await fetchEndereco(local.latitude, local.longitude);

        Ocorrencia ocorrencia = Ocorrencia(
          idOcorrencia: doc.id,
          idUsuario: doc.get('idUsuario'),
          descricao: doc.get('descicao'),
          data: doc.get('data').toDate(),
          categoria: doc.get('categoria'),
          local: local,
          endereco: _endereco,
        );
        if (bairro != null) {
          fetchEndereco(local.latitude, local.longitude).then((value) {
            if (value.subLocality == bairro) {
              listaOcorrencias.add(ocorrencia);
            }
          });
        } else {
          listaOcorrencias.add(ocorrencia);
        }
      }
    }
    return listaOcorrencias;
  }

  Future<bool> addOcorrencia({
    @required String descricao,
    @required String categoria,
    @required DateTime data,
    @required gp.GeoPoint local,
    @required String idUsuario,
    List<File> imagens,
  }) async {
    // Converte geopoint local para o geopoint do Firestore
    GeoPoint localConvertido = GeoPoint(local.latitude, local.longitude);

    // Criação da ocorrência no banco de dados
    DocumentReference doc = await _db.collection('ocorrencias').add({
      'descicao': descricao,
      'categoria': categoria,
      'data': data,
      'local': localConvertido,
      'idUsuario': idUsuario,
    });

    // Objeto Ocorrencia criada
    Ocorrencia ocorrencia = Ocorrencia(
      idUsuario: doc.id,
      descricao: descricao,
      data: data,
      categoria: categoria,
      local: local,
    );

    // Envia imagens
    List<String> urlImagens = await uploadImagensOcorrencia(imagens, doc.id);

    print('[DEBUG] urlImagens = $urlImagens');
    print('[DEBUG] urlImagens.toList() = ${urlImagens.toList()}');

    await _db.collection('ocorrencias').doc(doc.id).update({
      'urlImagens': urlImagens.toList(),
    });

    notifyListeners();
    return doc != null;
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

  Future<List<String>> uploadImagensOcorrencia(
    List<File> imagens,
    String idOcorrencia,
  ) async {
    List<String> urlImagens = [];
    print('[DEBUG] uploadImagensOcorrencia');
    print('[DEBUG] uploadImagensOcorrencia imagens = $imagens');

    for (File imagem in imagens) {
      print('[DEBUG] uploadImagensOcorrencia element = $imagem');
      String path = 'imagens/ocorrencias/${imagem.hashCode}$idOcorrencia';
      String urlImagem = await uploadImagem(imagem, path);
      print('[DEBUG] uploadImagensOcorrencia urlImagem = $urlImagem');
      urlImagens.add(urlImagem);
      print('[DEBUG] uploadImagensOcorrencia urlImagens = $urlImagens');
    }
    return urlImagens;
  }

  Future<String> uploadImagem(File imagem, String caminho) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(caminho);
    print('Basename: ${Path.basename(imagem.path)}\n path: ${imagem.path}');
    StorageUploadTask uploadTask = storageReference.putFile(imagem);
    StorageTaskSnapshot _taskSnapshot = await uploadTask.onComplete;
    String path = await _taskSnapshot.ref.getPath();
    print('[debug] PATH = $path');
    return path;
    // print('File Uploaded ${}');
  }

  Future<List<String>> downloadUrlImagensOcorrencia(String idOcorrencia) async {
    print('[DEBUG] downloadUrlImagensOcorrencia($idOcorrencia)');
    List<String> urls = [];
    var resp = await _db.collection('ocorrencias').doc(idOcorrencia).get();
    List<dynamic> _urls = resp.data()['urlImagens'];
    print('[DDDDDDDDDDDDDDD] _urls = $_urls');
    for (var item in _urls) {
      urls.add(item.toString());
    }
    print(urls);
    return urls;

    // print('IMAGEM: $imagemURL');

    // return imagemURL;
  }

  Future<String> downloadImagemURL(String url) async {
    String imagemURL;

    imagemURL =
        await FirebaseStorage.instance.ref().child(url).getDownloadURL();

    print('IMAGEM: $imagemURL');

    return imagemURL;
  }
}
