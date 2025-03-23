import 'dart:convert';

import 'package:flutter/material.dart';

class PruebaApis extends StatefulWidget {
  const PruebaApis({Key? key}) : super(key: key);

  @override
  _PruebaApisState createState() => _PruebaApisState();
}

class _PruebaApisState extends State<PruebaApis> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prueba'),),
      body:
        Column(
          children: [
            ElevatedButton(onPressed: (){

            }, child: Text('Consultar'))
          ],
        ),

    );
  }
}
