import 'package:flutter/material.dart';
import 'package:movin_project/models/ocorrencia.dart';
import 'package:movin_project/views/items/item_ocorrencia.dart';
import 'package:movin_project/views/widgets/painel_cria_ocorrencia.dart';

class PainelOcorrencias extends StatefulWidget {
  final List<Ocorrencia> ocorrencias;

  PainelOcorrencias(this.ocorrencias);

  @override
  _PainelOcorrenciasState createState() => _PainelOcorrenciasState();
}

void _mostraCriaOcorrencia(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return PainelCriaOcorrencia();
    },
  );
}

class _PainelOcorrenciasState extends State<PainelOcorrencias> {
  Widget _imprimeOcorrencias() {
    return Container(
      child: Stack(
        children: [
          Container(
            child: ListView.builder(
              itemCount: widget.ocorrencias.length,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              itemBuilder: (context, index) {
                return ItemOcorrencia(widget.ocorrencias[index]);
              },
            ),
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: FloatingActionButton(
              child: Icon(
                Icons.add,
                size: 40,
                color: Colors.white,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                _mostraCriaOcorrencia(context);
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
