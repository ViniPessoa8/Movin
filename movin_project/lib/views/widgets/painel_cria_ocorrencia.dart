import 'package:flutter/material.dart';

class PainelCriaOcorrencia extends StatelessWidget {
  List<String> valores = ['Um', 'Dois', 'Três', 'Quatro'];

  @override
  Widget build(BuildContext context) {
    String dropdownValue = valores[0];
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            'Criar Ocorrência',
            style: Theme.of(context).textTheme.headline6,
          ),
          Container(
            child: Column(
              children: [
                DropdownButton<String>(
                  autofocus: true,
                  value: dropdownValue,
                  items: valores.map((elemento) {
                    return DropdownMenuItem(
                      value: elemento,
                      child: Text(elemento),
                    );
                  }).toList(),
                  onChanged: null,
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
            child: Text('Criar'),
          )
        ],
      ),
    );
  }
}
