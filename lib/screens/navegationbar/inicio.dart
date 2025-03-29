import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarjeto/utilis/cliente_tarjeto.dart';
import 'package:tarjeto/utilis/cliente_tarjeto_storage.dart';

import '../../config/config.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final ClienteTarjetoStorage storage = ClienteTarjetoStorage();
  ClienteTarjeto? clienteTarjeto;

  //Nombre del usuario
  String? _nombre;

  //Foto de perfil;
  String? _fotoBase64;
  Widget? imagenPerfil; // Variable para almacenar la imagen convertida


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cargarStorage();
  }

  //Funcion para cargar datos de storage a variables
  Future<void> _cargarStorage() async{
    ClienteTarjeto? cliente = await storage.getCliente();
    setState(() {
      clienteTarjeto = cliente;
      _nombre = cliente!.nombre;
      _fotoBase64 = cliente.fotoPerfil;
      _cargarImagen(_fotoBase64!);
    });
  }

  void _cargarImagen(String base64String) {
    Widget imagen = base64ToImage(base64String);
    setState(() {
      imagenPerfil = imagen; // Actualiza la variable en el estado
    });
  }


  Widget base64ToImage(String base64String) {
    if (base64String.startsWith("data:image/svg+xml;base64,")) {
      String svgString = utf8.decode(base64.decode(base64String.split(',')[1]));
      return SvgPicture.string(svgString);
    } else {
      dynamic bytes = base64.decode(base64String.split(',')[1]);
      return Image.memory(bytes, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TarjetoColors.rojoPrincipal,
        //appBar: AppBar(title: Text('Generador de Qr')),
        body: SafeArea(
          child:
          Container(
            color: TarjetoColors.white,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      //Imagen de perfil
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: TarjetoColors.rojoPrincipal.withOpacity(0.20),
                              blurRadius:10, // Desenfoque
                              spreadRadius: 0.2, // Expansión de la sombra
                              offset: Offset(0, 0), // Dirección (X, Y)
                            )
                          ],
                          borderRadius: BorderRadius.circular(100),
                          color: TarjetoColors.fieldBackground,
                        ),

                        child: ClipOval(
                            child: imagenPerfil ?? CircularProgressIndicator() //SvgPicture.asset(TarjetoImages.usersmile_rojo_icon)
                        ),
                      ),

                      // Texto del nombre
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('¡Hola', style: TarjetoTextStyle.normalRojoBold,),
                          Text('$_nombre!', style: TarjetoTextStyle.medianoTextColorBold,),
                        ],
                      )

                    ],
                  ),


                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text('Home page', ),

                      //BOTON QUE BORRA EL STORAGE
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: ElevatedButton(
                            onPressed: () async{
                              await storage.deleteCliente();
                              Navigator.pushNamed(context, '/');
                            },
                            child: Text('BORRAR STORAGE!!')
                        ),

                      )
                    ],
                  ),
                ],
              ),
            ),
          ),


        )

    );
  }


}
