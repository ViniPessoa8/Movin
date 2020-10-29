import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geopoint/geopoint.dart' as gp;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart' as mb;
import 'package:movin_project/model/usuario.dart';
import 'package:movin_project/view/pages/pagina_principal.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:movin_project/db/firebase_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
*  INDEX DAS PAGINAS
*  1 - BOAS VINDAS
*  2 - CADASTRO
*  3 - LOGIN
*  4 - MAPA
*  5 - OCORRENCIAS
*  6 - PERFIL
*/

class ModelView extends Model {
  List<Ocorrencia> ocorrencias;
  gp.GeoPoint localUsuario;
  Address enderecoUsuario;
  FirebaseController _fc;
  bool _dbIniciado;
  bool _aguardandoResposta;

  ModelView() {
    _usuarioLogado = false;
    _dbIniciado = false;
    _aguardandoResposta = false;
    indexPainelPrincipal = 0;
    iniciaDb();
    // ocorrencias = [];
  }

  // Firebase

  iniciaDb() async {
    _fc = FirebaseController();
    _dbIniciado = await _fc.inicializaFirestore();
    carregaDados();
  }

  get dbIniciado => _dbIniciado;
  get aguardandoResposta => _aguardandoResposta;

  /*** LOGIN ***/
  bool _usuarioLogado;

  get usuarioLogado => _usuarioLogado;
  get carregouOcorrencias => ocorrencias != null;
  get carregouLocalUsuario => localUsuario != null;

  void criaUsuario(Usuario usuario, String senha) async {
    try {
      UserCredential _uc = await _fc.addUsuarioAuth(usuario.email, senha);
      print('[DEBUG] criaUsuario() _uc.user.uid: ${_uc.user.uid}');
      _fc.addUsuarioBD(_uc.user.uid, usuario);
      notifyListeners();
    } catch (e) {
      print('[ERRO] mv.criaUsuario(): $e');
    }
  }

  Future<UserCredential> realizaLogin(String email, String senha) async {
    UserCredential _userCredential;
    if (_dbIniciado) {
      _aguardandoResposta = true;
      notifyListeners();

      print('realiza login');
      try {
        _userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: senha,
        );
        print('login completo');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('Não há usuário cadastrado com este email.');
          throw e;
        } else if (e.code == 'wrong-password') {
          print('senha incorreta');
          throw e;
        }
      }
      _aguardandoResposta = false;
      notifyListeners();
    }
    return _userCredential;
  }

  void escutaLogin(BuildContext context) {
    print('escuta login.');
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('Erro no login.');
      } else {
        print('Usuário logado com sucesso.');
        Navigator.of(context).pushReplacementNamed(PaginaPrincipal.nomeRota);
        // _usuarioLogado = true;
      }
    });
    // modelView.realizaLogin();
  }

  Future<Usuario> getUsuario(String id) async {
    Usuario _usuario = await _fc.fetchUsuario(id);
    return _usuario;
  }

  void deslogar() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  /*** MAIN ***/
  int indexPainelPrincipal;
  bool _dadosCarregados = false;

  get getOcorrencias => ocorrencias;
  get getEndereco => enderecoUsuario;
  get carregouDados => _dadosCarregados;

  void carregaDados() async {
    await atualizaLocalUsuario();
    await atualizaOcorrencias();
    notifyListeners();
    // escutaLogin();
  }

  //Atualizadores

  Future<void> atualizaOcorrencias({String bairro}) async {
    print('[DEBUG] atualizaOcorrencias($bairro)');
    if (_dbIniciado) {
      ocorrencias = await _fc.fetchOcorrencias(bairro: bairro);
    } else {
      ocorrencias = [];
    }
  }

  Future<void> atualizaLocalUsuario() async {
    print('[DEBUG] atualizaLocalUsuario()');
    if (_dbIniciado) {
      localUsuario = await _fc.fetchLocalUsuario();
      await atualizaEnderecoUsuario();
    }
  }

  Future<void> atualizaEnderecoUsuario() async {
    if (_dbIniciado) {
      enderecoUsuario = await _fc.fetchEndereco(
        localUsuario.latitude,
        localUsuario.longitude,
      );
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
      idUsuario: ocorrencia.idUsuario,
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
    _fc.uploadImagem(imagem);
  }

  Future<Image> downloadImagem() async {
    String imagemURL = await _fc.downloadImagemURL();
    Image imagem = Image.network(
      imagemURL,
      height: 350,
      loadingBuilder: (context, child, loadingProgress) {
        return loadingProgress == null
            ? child
            : Center(child: Text("Carregando Imagem..."));
      },
    );

    return imagem;
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

  deletaTodasOcorrencias() {
    _fc.deletaTodasOcorrencias();
  }

  // Endereço

  Future<Address> getEnderecoBD(double latitude, double longitude) async {
    Address result;
    result = await _fc.fetchEndereco(latitude, longitude);
    return result;
  }
}
