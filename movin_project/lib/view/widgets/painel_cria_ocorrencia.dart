import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/utils/dados_internos.dart';

class PainelCriaOcorrencia extends StatefulWidget {
  static String nomeRota = '/ocorrencia/criar';
  final ModelView mv;

  PainelCriaOcorrencia(this.mv);

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
              widget.mv.addOcorrencia(
                descricao: descricaoController.text,
                categoria: categoria,
                data: DateTime.now(),
                local: widget.mv.localUsuario,
                idUsuario: 0,
              );
              widget.mv.fetchOcorrencias();
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
