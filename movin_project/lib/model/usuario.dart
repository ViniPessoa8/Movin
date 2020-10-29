import 'package:flutter/material.dart';

class Usuario {
  // final String idUsuario;
  String email;
  String nome;
  bool pcd; // Pessoa com Deficiência
  String urlFotoPerfil;
  List<int> idRotasFavoritas; // Armazena o id das rotas favoritas
  // String senha; /* senha será verificada diretamente do banco de dadose não deve ser armazenada. */

  Usuario({
    // @required this.idUsuario,
    @required this.email,
    @required this.nome,
    @required this.pcd,
    this.urlFotoPerfil,
    this.idRotasFavoritas,
  });
}
