import 'package:location/location.dart';
import 'package:movin_project/model/ocorrencia.dart';

class DadosInternos {
  static final List<String> categorias = [
    'Assalto e Furto',
    'Acidente',
    'Buraco',
    'Calçada Irregular',
    'Congestionamento',
    'Entulho',
    'Iluminação',
    'Obra',
  ];

  static final List<Ocorrencia> OCORRENCIAS_EXEMPLO = [
    Ocorrencia(
      idOcorrencia: 0,
      idAutor: 0,
      titulo: 'Assalto',
      descricao: 'Assalto à mão armada',
      categoria: 'Assaltos e Furtos',
      data: DateTime.now(),
      // local: null,
    ),
    Ocorrencia(
      idOcorrencia: 1,
      idAutor: 0,
      titulo: 'Buraco',
      descricao: 'Buraco na calçada',
      categoria: 'Infraestrutura',
      data: DateTime.now(),
      // local: null,
    ),
    Ocorrencia(
      idOcorrencia: 2,
      idAutor: 1,
      titulo: 'Trânsito',
      descricao: 'Trânsito intenso sentido bairro.',
      categoria: 'Trânsito',
      data: DateTime.now(),
      // local: null,
    ),
    // Ocorrencia(
    //   idOcorrencia: 3,
    //   idAutor: 2,
    //   titulo: 'TESTEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE',
    //   descricao: 'Testeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee.',
    //   categoria: 'testeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',
    //   data: DateTime.now(),
    //   // local: null,
    // ),
    // Ocorrencia(
    //   idOcorrencia: 4,
    //   idAutor: 2,
    //   titulo: 'Jogador de Free-Fire',
    //   descricao: 'Pessoa jogando Free-Fire publicamente.',
    //   categoria: 'Desrespeito Geral',
    //   data: DateTime.now(),
    //   // local: null,
    // ),
  ];
}
