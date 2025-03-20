import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/config.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TarjetoColors.rojoPrincipal,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const Padding(
                padding: const EdgeInsets.fromLTRB(25, 60, 25, 60),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Únete a',
                          style:
                          TarjetoTextStyle.tituloExtraGrandeBlancoExtBold,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'tarjeto',
                          style:
                          TarjetoTextStyle.tituloExtraGrandeBlancoExtBold,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                //Contenedor blanco
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: TarjetoColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: Column(
                      children: [

                        // Logo rojo
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                          child: Row(children: [
                            Container(
                              child: Image.asset(TarjetoImages.logoRojoConLetras),
                              width: 150,
                            )
                          ]),
                        ),

                        //Debajo del logo rojo
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [

                                  //Input nombre
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: TarjetoColors.fieldOutline, width: 2),
                                      color: TarjetoColors.fieldBackground,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextField(
                                      // controller: _emailController,
                                      cursorColor: TarjetoColors.fieldOutline,
                                      decoration: InputDecoration(
                                        labelText: 'Nombre',
                                        labelStyle: TarjetoTextStyle.placeholderInput,
                                        hintText: 'Escribe tu nombre',
                                        hintStyle: TarjetoTextStyle.placeholderInput,
                                        prefixIcon: Padding(
                                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                            child: SvgPicture.asset(
                                              TarjetoImages.profileIcon,
                                              width: 25,
                                              height: 25,
                                            )),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),

                                  //Input Correo
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: TarjetoColors.fieldOutline, width: 2),
                                      color: TarjetoColors.fieldBackground,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextField(
                                      // controller: _emailController,
                                      cursorColor: TarjetoColors.fieldOutline,
                                      decoration: InputDecoration(
                                        labelText: 'Correo electronico',
                                        labelStyle: TarjetoTextStyle.placeholderInput,
                                        hintText: 'Escribe tu correo electrónico',
                                        hintStyle: TarjetoTextStyle.placeholderInput,
                                        prefixIcon: Padding(
                                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                            child: SvgPicture.asset(
                                              TarjetoImages.emailIcon,
                                              width: 25,
                                              height: 25,
                                            )),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),

                                  //Input contraseña
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 30),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: TarjetoColors.fieldOutline, width: 2),
                                      color: TarjetoColors.fieldBackground,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextField(
                                      cursorColor: TarjetoColors.fieldOutline,
                                      obscureText: true,
                                      //controller: _emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña',
                                        labelStyle: TarjetoTextStyle.placeholderInput,
                                        hintText: 'Crea tu contraseña',
                                        hintStyle: TarjetoTextStyle.placeholderInput,
                                        prefixIcon: Padding(
                                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                            child: SvgPicture.asset(
                                              TarjetoImages.contrasenaIcon,
                                              width: 25,
                                              height: 25,
                                            )),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),

                                  //Boton siguiente
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
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
                                            onPressed: () {
                                              Navigator.pushNamed(context, '/verificarcorreo');
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Siguiente",
                                                  style: TarjetoTextStyle.btnTextBlanco,
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
                                      )
                                    ],
                                  ),

                                  // Texto no tienes cuenta
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                                    child: Row(
                                      children: [
                                        Text('¿Ya tienes cuenta? ¡Inicia sesión ',style: TarjetoTextStyle.medianoTextColorBold,),
                                        GestureDetector(child: Text('aqui!', style: TarjetoTextStyle.medianoRojoBold,), onTap: () {
                                          Navigator.pushNamed(context, '/login');
                                        },)
                                      ],
                                    ),
                                  ),


                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    decoration: BoxDecoration(
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: TarjetoColors.rojoPrincipal,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              )
            ],
          )),
    );
  }
}
