import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movin_project/utils/dados_internos.dart';
import 'package:movin_project/view/widgets/painel_mapa.dart';
import 'package:movin_project/view/widgets/painel_ocorrencias.dart';
import 'package:movin_project/view/widgets/painel_perfil.dart';
import 'package:scoped_model/scoped_model.dart';

class ModelView extends Model {
  /*** LOGIN ***/

  bool _dbIniciado = false;
  bool _usuarioLogado = false;

  get usuarioLogou => _usuarioLogado;

  void realizaLogin() {
    _usuarioLogado = true;
    notifyListeners();
  }

  /*** FIREBASE ***/

  void inicializaFirestore() async {
    try {
      await Firebase.initializeApp();
      _dbIniciado = true;
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar Banco de Dados (Firebase):\n$e');
    }
  }

  getOcorrencia() {
    if (_dbIniciado) {
      FirebaseFirestore.instance
          .collection('ocorrencias/tJceIBXVieL1i0ZuAsWJ/ocorrencia')
          .snapshots()
          .listen((data) {
        data.docs.forEach((element) {
          print(element['titulo']);
        });
      });
    }
  }

  /*** MAIN ***/
  int indexPainelPrincipal = 0;
  List<Map<String, Object>> paginas = [
    {
      'pagina': PainelMapa(),
      'titulo': 'Mapa',
    },
    {
      'pagina': PainelOcorrencias(DadosInternos.OCORRENCIAS_EXEMPLO),
      'titulo': 'Ocorrências',
    },
    {
      'pagina': PainelPerfil(),
      'titulo': 'Perfil',
    },
  ];

  void selecionaPagina(int index) {
    indexPainelPrincipal = index;
    print('$indexPainelPrincipal, $index');
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
