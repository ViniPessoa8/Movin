import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/view/widgets/principal/item_ocorrencia.dart';
import 'package:loading/loading.dart';

class PainelOcorrencias extends StatefulWidget {
  final ModelView _mv;
  // final BuildContext context;

  PainelOcorrencias(this._mv);

  @override
  _PainelOcorrenciasState createState() => _PainelOcorrenciasState();
}

class _PainelOcorrenciasState extends State<PainelOcorrencias>
    with AutomaticKeepAliveClientMixin<PainelOcorrencias> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('ocorrencias').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: _buildListaOcorrencias(),
          );
        } else {
          return Text('Carregado...');
        }
      },
    );
  }

  Widget _buildListaOcorrencias() {
    if (widget._mv.carregouOcorrencias && widget._mv.carregouLocalUsuario) {
      if (widget._mv.ocorrencias == null) {
        return Text('ocorrencias null');
      } else if (widget._mv.ocorrencias.isEmpty) {
        return Container(
          alignment: Alignment.center,
          child: RefreshIndicator(
            onRefresh: widget._mv.atualizaOcorrencias,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (ctx, index) {
                return Align(
                  heightFactor: 30.0, // ?
                  child: Text(
                    'Não há ocorrências',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
          ),
        );
      }

      return Container(
        child: Stack(
          children: [
            Container(
              child: RefreshIndicator(
                onRefresh: widget._mv.atualizaOcorrencias,
                child: ListView.builder(
                  itemCount: widget._mv.ocorrencias.length,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  itemBuilder: (context, index) {
                    return ItemOcorrencia(
                      widget._mv,
                      index,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Loading(
              indicator: BallPulseIndicator(),
              size: 50.0,
              color: Theme.of(context).accentColor,
            ),
            Text('Carregando ocorrêncais...'),
          ],
        ),
      );
    }
  }
}
