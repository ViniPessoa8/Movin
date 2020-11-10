import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class FilterBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MultiSelectFormField(
        dataSource: [
          {
            'display': 'Meu bairro',
            'value': 'Bairro',
          }
        ],
        textField: 'display',
        valueField: 'value',
        onSaved: (newValue) {
          print('Valor: $newValue');
        },
      ),
    );
  }
}
