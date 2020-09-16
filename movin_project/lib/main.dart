import 'package:flutter/material.dart';
import 'package:movin_project/views/pages/pagina_principal.dart';
import 'package:movin_project/views/widgets/painel_emergencia.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Movin',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange[600],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => PaginaPrincipal(),
          PainelEmergencia.nomeRota: (ctx) => PainelEmergencia(),
        });
  }
}
