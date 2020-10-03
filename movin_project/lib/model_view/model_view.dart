import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:movin_project/utils/dados_internos.dart';
import 'package:movin_project/view/widgets/painel_mapa.dart';
import 'package:movin_project/view/widgets/painel_ocorrencias.dart';
import 'package:movin_project/view/widgets/painel_perfil.dart';
import 'package:scoped_model/scoped_model.dart';

class ModelView extends Model {
  bool _carregouOcorrencias = false;
  List<Ocorrencia> ocorrencias;

  /*** LOGIN ***/

  bool _dbIniciado = false;
  bool _usuarioLogado = true;

  get usuarioLogou => _usuarioLogado;
  get carregouOcorrencias => _carregouOcorrencias;

  void realizaLogin() {
    _usuarioLogado = true;
    notifyListeners();
  }

  /*** FIREBASE ***/

  void inicializaFirestore() async {
    try {
      await Firebase.initializeApp();
      _dbIniciado = true;
      await fetchOcorrencias();
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar Banco de Dados (Firebase):\n$e');
    }
  }

  fetchOcorrencias() async {
    List<Ocorrencia> listaOcorrencias = [];
    if (_dbIniciado) {
      await FirebaseFirestore.instance.collection('ocorrencias').get().then(
        (value) {
          value.docs.forEach(
            (element) {
              Ocorrencia ocorrencia = Ocorrencia(
                idOcorrencia: 0,
                idAutor: 0,
                titulo: element.get('titulo'),
                descricao: element.get('descicao'),
                data: element.get('data').toDate(),
                categoria: element.get('categoria'),
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

  /*** MAIN ***/
  int indexPainelPrincipal = 1;

  get getOcorrencias => ocorrencias;

  void selecionaPagina(int index) {
    indexPainelPrincipal = index;
    notifyListeners();
  }

  // void logaUsuario(BuildContext context) {
  //   print('loga usuario.');
  //   setState(() {
  //     widget.usuarioLogado = true;
  //     Navigator.of(context).pushReplacementNamed(PaginaPrincipal.nomeRota);
  //   });
  // }
}
