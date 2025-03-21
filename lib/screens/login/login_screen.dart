import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                          'Bienvenido',
                          style:
                              TarjetoTextStyle.tituloExtraGrandeBlancoExtBold,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'de nuevo',
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
                              //Input Correo
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
                                    hintText: 'Ingresa tu contraseña',
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

                              //Boton ingresar
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
                                         Navigator.pushNamed(context, '/navigationbarprincipal');
                                        },
                                        child: Text(
                                          "Ingresar",
                                          style: TarjetoTextStyle.btnTextBlanco,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              // Texto no tienes cuenta
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Text('¿No tienes cuenta?',style: TarjetoTextStyle.medianoTextColorBold,),
                              ),

                              Row(
                                // Boton crear cuenta
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: TarjetoColors.fieldOutline,
                                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                          side: const BorderSide(color: TarjetoColors.rojoPrincipal, width: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/signup');
                                        },
                                        child: Text(
                                          "Crear cuenta",
                                          style: TarjetoTextStyle.btnTextRojo,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
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
