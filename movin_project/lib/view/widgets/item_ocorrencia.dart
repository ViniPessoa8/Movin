import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:intl/intl.dart';
import 'package:movin_project/model_view/model_view.dart';

class ItemOcorrencia extends StatefulWidget {
  final int indexOcorrencia;
  final ModelView mv;

  ItemOcorrencia(this.mv, this.indexOcorrencia);

  @override
  _ItemOcorrenciaState createState() => _ItemOcorrenciaState();
}

class _ItemOcorrenciaState extends State<ItemOcorrencia> {
  final DateFormat formatadorData = DateFormat('dd/MM/yyyy');

  Address endereco;
  Ocorrencia ocorrencia;

  @override
  void initState() {
    ocorrencia = widget.mv.ocorrencias[widget.indexOcorrencia];
    carregaEndereco();
    super.initState();
  }

  carregaEndereco() async {
    print('carregaEndereco()');
    double latitude = ocorrencia.local.latitude;
    double longitude = ocorrencia.local.longitude;

    Address localEnd = await widget.mv.getEnderecoBD(latitude, longitude);
    setState(() {
      endereco = localEnd;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).accentColor,
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            size: 50,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 269,
                maxHeight: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ocorrencia.categoria,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 25,
                        ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Text(
                    ocorrencia.descricao,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 20,
                        ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Text(
                    formatadorData.format(ocorrencia.data),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 20,
                        ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Text(
                    endereco == null
                        ? '(Sem Endereço)'
                        : widget.mv.formatEndereco(endereco),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 17,
                        ),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
