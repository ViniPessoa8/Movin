import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ModelView {
  /*** LOGIN ***/

  bool _dbIniciado = false;
  bool _usuarioLogado = false;

  get usuarioLogou => _usuarioLogado;
  set usuarioLogou(value) => _usuarioLogado = value;

  void realizaLogin() => usuarioLogou(true);

  /*** FIREBASE ***/

  void inicializaFirestore() async {
    try {
      await Firebase.initializeApp();
      _dbIniciado = true;
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

  // void logaUsuario(BuildContext context) {
  //   print('loga usuario.');
  //   setState(() {
  //     widget.usuarioLogado = true;
  //     Navigator.of(context).pushReplacementNamed(PaginaPrincipal.nomeRota);
  //   });
  // }
}
