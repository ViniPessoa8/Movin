import 'package:flutter/material.dart';

class PainelCarregamento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
