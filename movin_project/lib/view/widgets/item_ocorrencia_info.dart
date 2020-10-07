import 'package:flutter/material.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:movin_project/model_view/model_view.dart';

class ItemOcorrenciaInfo extends StatelessWidget {
  final Ocorrencia ocorrencia;
  final ModelView mv;

  ItemOcorrenciaInfo(this.mv, this.ocorrencia);

  @override
  Widget build(BuildContext context) {
    print('Building ItemOcorrenciaInfo');
    return Container(
      child: SimpleDialog(
        contentPadding: EdgeInsets.only(
          right: 10,
          left: 10,
          bottom: 10,
        ),
        children: [
          Image(
            image: AssetImage('assets/media/google_logo.png'),
            height: 200,
          ),
          Text(
            ocorrencia.categoria,
            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 40),
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
          ),
          Text(
            mv.formatData(ocorrencia.data),
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18),
          ),
          Text(
            ocorrencia.descricao,
            style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 30),
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
          ),
          InkWell(
            onTap: () => print('Mostrar local no mapa'),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 260,
                    child: Text(
                      mv.formatEndereco(ocorrencia.endereco),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: 20,
                            color: Colors.grey[600],
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      softWrap: false,
                    ),
                  ),
                  Icon(Icons.location_on),
                ],
              ),
            ),
          ),
          Text(
            'Autor: -',
            style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            softWrap: false,
          ),
        ],
      ),
    );
  }
}
