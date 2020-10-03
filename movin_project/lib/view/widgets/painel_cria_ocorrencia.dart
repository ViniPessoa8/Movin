import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movin_project/utils/dados_internos.dart';

class PainelCriaOcorrencia extends StatefulWidget {
  static String nomeRota = '/ocorrencia/criar';

  @override
  _PainelCriaOcorrenciaState createState() => _PainelCriaOcorrenciaState();
}

class _PainelCriaOcorrenciaState extends State<PainelCriaOcorrencia> {
  List<String> valores = DadosInternos.categorias;
  String categoria;
  CollectionReference ocorrencias =
      FirebaseFirestore.instance.collection('ocorrencias');
  TextEditingController tituloController = new TextEditingController();
  TextEditingController descricaoController = new TextEditingController();

  Future<void> addOcorrencia(
      {String titulo,
      String descricao,
      String categoria,
      DateTime data,
      int idUsuario}) {
    return ocorrencias.add({
      'titulo': titulo,
      'descicao': descricao,
      'categoria': categoria,
      'data': data,
      'userId': idUsuario
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Criar Ocorrência',
            style: Theme.of(context).textTheme.headline6,
          ),
          Divider(
            color: Colors.black,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      autofocus: true,
                      hint: Text('Selecione a Categoria'),
                      value: categoria,
                      items: valores.map((elemento) {
                        return DropdownMenuItem(
                          value: elemento,
                          child: Text(elemento),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          categoria = value;
                        });
                      },
                    ),
                  ],
                ),
                TextField(
                  controller: tituloController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                ),
                TextField(
                  controller: descricaoController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                ),
                FlatButton(
                  onPressed: null,
                  child: Row(
                    children: [
                      Icon(Icons.add_location),
                      Text('Adicionar Localização'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      child: Icon(Icons.add_a_photo, size: 70),
                      onPressed: null,
                    ),
                    FlatButton(
                      child: Icon(Icons.add_a_photo, size: 70),
                      onPressed: null,
                    ),
                    FlatButton(
                      child: Icon(Icons.add_a_photo, size: 70),
                      onPressed: null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () {
              addOcorrencia(
                titulo: tituloController.text,
                descricao: descricaoController.text,
                categoria: categoria,
                data: DateTime.now(),
                idUsuario: 0,
              );
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('Ocorrência criada com sucesso.'),
                    actions: [
                      RaisedButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                },
              );
            },
            child: Text('Criar Ocorrência'),
          ),
        ],
      ),
    );
  }
}
