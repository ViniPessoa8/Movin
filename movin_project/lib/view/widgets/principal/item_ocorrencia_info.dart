import 'package:flutter/material.dart';
import 'package:movin_project/model/ocorrencia.dart';
import 'package:movin_project/model_view/model_view.dart';

class ItemOcorrenciaInfo extends StatefulWidget {
  final Ocorrencia ocorrencia;
  final ModelView mv;
  // Se a ocorrência foi selecionada no mapa ou não. Se sim, não é mostrado
  final bool doMapa;

  ItemOcorrenciaInfo(
    this.mv,
    this.ocorrencia,
    this.doMapa,
  );

  @override
  _ItemOcorrenciaInfoState createState() => _ItemOcorrenciaInfoState();
}

class _ItemOcorrenciaInfoState extends State<ItemOcorrenciaInfo> {
  // Imagem
  List<Image> imagens;
  // Util
  bool imagensCarregadas = false;

  @override
  void initState() {
    carregaDados();
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
            widget.ocorrencia.categoria,
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
                widget.mv.formatData(widget.ocorrencia.data),
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
            widget.ocorrencia.descricao,
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 25),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            softWrap: false,
          ),
          InkWell(
            onTap: () {
              if (!widget.doMapa) {
                widget.mv.selecionaPagina(0);
                widget.mv.ocorrenciaSelecionada = widget.ocorrencia;
                print(widget.ocorrencia.idOcorrencia);
              }
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
                      widget.mv.formatEndereco(widget.ocorrencia.endereco),
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

  void carregaDados() async {
    // downloadImagem('imagens/imagem_teste.jpg');
    List<String> _urls = await widget.mv
        .downloadUrlImagensOcorrencia(widget.ocorrencia.idOcorrencia);
    downloadImagens(_urls);
  }

  // Carrega a imagem da ocorrencia
  void downloadImagens(List<String> urls) async {
    print('[DEBUG] downloadImagens($urls)');
    List<Image> _imagens = [];
    for (String url in urls) {
      Image img = await widget.mv.downloadImagem(url);
      _imagens.add(img);
    }
    imagensCarregadas = true;

    setState(() {
      imagens = _imagens;
    });
  }

  /* Builders */

  // Retorna a imagem carregada
  Widget _mostraImagens() {
    if (imagensCarregadas && imagens != null) {
      return Container(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: imagens.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Image(
                image: imagens[index].image,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      );
    } else if (imagensCarregadas) {
      return Center(
        child: Text('(Sem Imagens)'),
      );
    } else {
      return Center(child: Text("Carregando Imagem..."));
    }
  }
}
