import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:multiselect_formfield/multiselect_dialog.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class FilterBox extends StatefulWidget {
  final ModelView mv;
  final BuildContext context;

  FilterBox(this.context, this.mv);

  @override
  _FilterBoxState createState() => _FilterBoxState();
}

class _FilterBoxState extends State<FilterBox> {
  MultiSelectDialog<String> filterBox;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: MultiSelect(
          autovalidate: false,
          titleText: 'Filtros',
          validator: (value) {
            if (value == null) {
              return 'Please select one or more option(s)';
            }
          },
          errorText: 'Please select one or more option(s)',
          dataSource: [
            {
              "display": "Assaltos",
              "value": 1,
            },
            {
              "display": "Furtos",
              "value": 2,
            },
            {
              "display": "Acidentes",
              "value": 3,
            },
            {
              "display": "Iluminação",
              "value": 4,
            }
          ],
          textField: 'display',
          valueField: 'value',
          filterable: true,
          required: true,
          value: null,
          onSaved: (value) {
            print('The value is $value');
          }),
    );

    return Container(
      width: 100,
      child: MultiSelectFormField(
        title: Text('Filtros'),
        dataSource: [
          {'display': 'Meu Bairro', 'value': 'Bairro'},
          {'display': 'Minha Cidade', 'value': 'Cidade'}
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
