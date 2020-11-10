import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:intl/intl.dart';
import 'package:movin_project/model_view/model_view.dart';
import 'package:movin_project/view/widgets/principal/item_ocorrencia_info.dart';

class ItemOcorrencia extends StatefulWidget {
  final int _indexOcorrencia;
  final ModelView _mv;

  ItemOcorrencia(this._mv, this._indexOcorrencia);

  @override
  _ItemOcorrenciaState createState() => _ItemOcorrenciaState();
}

class _ItemOcorrenciaState extends State<ItemOcorrencia> {
  final DateFormat _formatadorData = DateFormat('dd/MM/yyyy');
  Address _endereco;
  Ocorrencia _ocorrencia;

  @override
  void initState() {
    _ocorrencia = widget._mv.ocorrencias[widget._indexOcorrencia];
    _carregaEndereco();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) =>
            ItemOcorrenciaInfo(widget._mv, _ocorrencia, false),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).accentColor,
        ),
        child: Row(
          // Ícone
          children: [
            Icon(
              Icons.warning,
              size: 50,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 295,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      // decoration: BoxDecoration(border: Border.all()),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Categoria
                          Container(
                            width: 190,
                            child: Text(
                              _ocorrencia.categoria,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontSize: 30,
                                  ),
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                          //Data
                          Container(
                            child: Text(
                              widget._mv.formatData(_ocorrencia.data),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: 18,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.right,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Descrição
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        _ocorrencia.descricao,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 20,
                            ),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    // Endereço
                    Text(
                      _endereco == null
                          ? '(Sem Endereço)'
                          : widget._mv.formatEndereco(_endereco),
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
      ),
    );
  }

  /* Functions */

  void _carregaEndereco() async {
    print('carregaEndereco()');
    double latitude = _ocorrencia.local.latitude;
    double longitude = _ocorrencia.local.longitude;

    Address localEnd = await widget._mv.getEnderecoBD(latitude, longitude);
    setState(() {
      _endereco = localEnd;
      _ocorrencia.endereco = _endereco;
    });
  }
}
