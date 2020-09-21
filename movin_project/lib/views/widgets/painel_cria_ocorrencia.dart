import 'package:flutter/material.dart';
import 'package:movin_project/utils/dados_internos.dart';

class PainelCriaOcorrencia extends StatefulWidget {
  @override
  _PainelCriaOcorrenciaState createState() => _PainelCriaOcorrenciaState();
}

class _PainelCriaOcorrenciaState extends State<PainelCriaOcorrencia> {
  List<String> valores = DadosInternos.categorias;
  String dropdownValue;

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
                    Text('Categoria:'),
                    SizedBox(
                      width: 30,
                    ),
                    DropdownButton<String>(
                      autofocus: true,
                      hint: Text('Selecione a Categoria'),
                      value: dropdownValue,
                      items: valores.map((elemento) {
                        return DropdownMenuItem(
                          value: elemento,
                          child: Text(elemento),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value;
                        });
                      },
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                ),
                TextField(
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
