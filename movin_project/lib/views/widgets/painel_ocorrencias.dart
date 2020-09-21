import 'package:flutter/material.dart';
import 'package:movin_project/models/ocorrencia.dart';
import 'package:movin_project/views/items/item_ocorrencia.dart';

class PainelOcorrencias extends StatefulWidget {
  final List<Ocorrencia> ocorrencias;

  PainelOcorrencias(this.ocorrencias);

  @override
  _PainelOcorrenciasState createState() => _PainelOcorrenciasState();
}

class _PainelOcorrenciasState extends State<PainelOcorrencias> {
  Widget _imprimeOcorrencias() {
    return ListView.builder(
      itemCount: widget.ocorrencias.length,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      itemBuilder: (context, index) {
        return ItemOcorrencia(widget.ocorrencias[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.ocorrencias.isEmpty
          ? Text('Não há ocorrências.')
          : _imprimeOcorrencias(),
    );
  }
}
