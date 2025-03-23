import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/config.dart';

class SubirFotoPerfil extends StatefulWidget {
  const SubirFotoPerfil({Key? key}) : super(key: key);

  @override
  _SubirFotoPerfilState createState() => _SubirFotoPerfilState();
}

class _SubirFotoPerfilState extends State<SubirFotoPerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TarjetoColors.white,
      body: SafeArea(
          bottom: false,
          child: Container(color: TarjetoColors.white,

            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(children: [
                    Container(
                      child: Image.asset(TarjetoImages.logoRojoConLetras),
                      width: 200,
                      padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child:
                    Text(
                      'Te enviamos un código a tu correo para confirmar que eres tú.',
                      style: TarjetoTextStyle.grandeTextColorMedium,
                    ),
                  ),

                  //Container ingresar codigo
                  Container(
                    margin: EdgeInsets.all(25),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: TarjetoColors.fieldBackground,
                        borderRadius: BorderRadius.circular(25)
                    ),
                    padding: EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius:10, // Desenfoque
                              spreadRadius: 0.2, // Expansión de la sombra
                              offset: Offset(0, 0), // Dirección (X, Y)
                            )
                          ],
                          color: TarjetoColors.white,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          //Texto ingresar código
                          Text(
                            'Ingresa tu código',
                            style: TarjetoTextStyle.medianoNegroBold,
                          ),


                        ],
                      ),
                    ),
                  ),



                  // Botón siguiente
                  Container(
                    margin: const EdgeInsets.fromLTRB(25, 40, 25, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TarjetoColors.rojoPrincipal,
                        foregroundColor: TarjetoColors.fieldOutline,
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        elevation: 0,
                      ),
                      onPressed: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Siguiente",
                            style: TarjetoTextStyle.btnTextBlanco
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: SvgPicture.asset(TarjetoImages.flechaDerechaIcon,
                              width: 20,
                              height: 20,),
                          )
                        ],
                      ),
                    ),
                  ),



                ],
              ),
            ),
          )
      ),


    );
  }
}
