import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/view/widgets/principal/filter_box.dart';
import 'package:movin_project/view/widgets/principal/item_ocorrencia.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:loading/loading.dart';

class PainelOcorrencias extends StatelessWidget {
  final ModelView mv;
  final BuildContext context;

  PainelOcorrencias(this.context, this.mv);

  Widget _imprimeOcorrencias() {
    if (mv.carregouOcorrencias && mv.carregouLocalUsuario) {
      if (mv.ocorrencias == null) {
        return Text('ocorrencias null');
      } else if (mv.ocorrencias.isEmpty) {
        return Container(
          alignment: Alignment.center,
          child: RefreshIndicator(
            onRefresh: mv.atualizaOcorrencias,
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
                onRefresh: mv.atualizaOcorrencias,
                child: ListView.builder(
                  itemCount: mv.ocorrencias.length,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  itemBuilder: (context, index) {
                    return ItemOcorrencia(
                      mv,
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

  @override
  Widget build(BuildContext context) {
    return
        // ScopedModelDescendant<ModelView>(
        //   builder: (context, child, model) {
        //     return
        StreamBuilder(
      stream: FirebaseFirestore.instance.collection('ocorrencias').snapshots(),
      builder: (context, snapshot) {
        // model.atualizaOcorrencias();
        if (snapshot.hasData) {
          return Center(
            child: _imprimeOcorrencias(),
          );
        } else {
          return Text('Carregado...');
        }
      },
    );
    // },
    // );
  }
}
