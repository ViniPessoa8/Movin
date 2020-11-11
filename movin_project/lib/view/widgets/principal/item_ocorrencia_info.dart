import 'package:flutter/material.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:movin_project/model_view/model_view.dart';

class ItemOcorrenciaInfo extends StatefulWidget {
  final Ocorrencia _ocorrencia;
  final ModelView _mv;
  // Se a ocorrência foi selecionada no mapa ou não. Se sim, não é mostrado
  final bool _doMapa;

  ItemOcorrenciaInfo(
    this._mv,
    this._ocorrencia,
    this._doMapa,
  );

  @override
  _ItemOcorrenciaInfoState createState() => _ItemOcorrenciaInfoState();
}

class _ItemOcorrenciaInfoState extends State<ItemOcorrenciaInfo> {
  // Imagem
  List<Image> _imagens;
  // Util
  bool _imagensCarregadas = false;

  @override
  void initState() {
    _carregaDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: SimpleDialog(
        contentPadding: EdgeInsets.all(10),
        children: [
          // Categoria
          Text(
            widget._ocorrencia.categoria,
            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 40),
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Data
              Text(
                widget._mv.formatData(widget._ocorrencia.data),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          // Descrição
          Text(
            widget._ocorrencia.descricao,
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 25),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            softWrap: false,
          ),
          InkWell(
            onTap: () {
              widget._mv.irLocalOcorrencia(widget._ocorrencia);
              Navigator.of(context).canPop()
                  ? Navigator.of(context).pop()
                  : null;
            },
            // Endereço
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
                      widget._mv.formatEndereco(widget._ocorrencia.endereco),
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
          SizedBox(
            height: 15,
          ),
          SizedBox(height: 15),
          Divider(thickness: 1, color: Colors.black),
          // Imagens da ocorrencia
          Container(
            height: 100,
            width: 300,
            child: _mostraImagens(),
          ),
        ],
      ),
    );
  }

  /* Functions */

  void _carregaDados() async {
    // downloadImagem('imagens/imagem_teste.jpg');
    List<String> _urls = await widget._mv
        .downloadUrlImagensOcorrencia(widget._ocorrencia.idOcorrencia);
    _downloadImagens(_urls);
  }

  // Carrega a imagem da ocorrencia
  void _downloadImagens(List<String> urls) async {
    print('[DEBUG] downloadImagens($urls)');
    List<Image> _imagensList = [];
    for (String url in urls) {
      Image img = await widget._mv.downloadImagem(url);
      _imagensList.add(img);
    }
    _imagensCarregadas = true;

    setState(() {
      _imagens = _imagensList;
    });
  }

  void irLocalOcorrencia(Ocorrencia ocorrencia) {}

  /* Builders */

  // Retorna a imagem carregada
  Widget _mostraImagens() {
    if (_imagensCarregadas && _imagens != null) {
      return Container(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _imagens.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Container(
                        child: Image(
                          image: _imagens[index].image,
                          height: 400,
                          width: 300,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  );
                },
                child: Image(
                  image: _imagens[index].image,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    } else if (_imagensCarregadas) {
      return Center(
        child: Text('(Sem Imagens)'),
      );
    } else {
      return Center(child: Text("Carregando Imagem..."));
    }
  }
}
