import 'package:flutter/material.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:movin_project/view/widgets/item_ocorrencia.dart';
import 'package:movin_project/view/widgets/painel_cria_ocorrencia.dart';

class PainelOcorrencias extends StatefulWidget {
  final List<Ocorrencia> ocorrencias;

  PainelOcorrencias(this.ocorrencias);

  @override
  _PainelOcorrenciasState createState() => _PainelOcorrenciasState();
}

class _PainelOcorrenciasState extends State<PainelOcorrencias> {
  Widget _imprimeOcorrencias() {
    return Container(
      child: Stack(
        children: [
          Container(
            child: ListView.builder(
              itemCount: widget.ocorrencias.length,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              itemBuilder: (context, index) {
                return ItemOcorrencia(widget.ocorrencias[index]);
              },
            ),
          ),
        ],
      ),
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
