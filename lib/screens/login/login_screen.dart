import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:tarjeto/utilis/cliente_tarjeto.dart';
import 'package:tarjeto/utilis/cliente_tarjeto_storage.dart';

import '../../config/config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ClienteTarjetoStorage storage = ClienteTarjetoStorage();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login() async {
    //Defino un cliente de tarjeto con el STORAGE
    ClienteTarjeto? clienteTarjeto = await storage.getCliente();


    final String apiUrl = "https://api.tarjeto.app/api/auth/login";
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cliente': 'flutter-app',
    };

    final Map<String, String> body = {
      'email': _emailController.text,
      'contrasena': _passwordController.text,
    };

    try {
      final client = http.Client();
      final request = http.Request("POST", Uri.parse(apiUrl))
        ..headers.addAll(headers)
        ..body = jsonEncode(body);

      final response = await client.send(request);

      // Detecta si hay redirección (307)
      if (response.statusCode == 307) {
        final newUrl = response.headers['location']; // Obtiene la nueva URL
        if (newUrl != null) {
          print("Redirigiendo a: $newUrl");

          final newResponse = await http.post(
            Uri.parse(newUrl),
            headers: headers,
            body: jsonEncode(body),
          );

          if (newResponse.statusCode == 200) {
            final Map<String, dynamic> responseData = jsonDecode(newResponse.body);
            //print("Login exitoso: ${responseData}");

            clienteTarjeto?.nombre = responseData['user']['nombre'];
            clienteTarjeto?.email = responseData['user']['email'];
            clienteTarjeto?.token = responseData['token'];
            clienteTarjeto?.verificado = responseData['user']['verificado'];
            clienteTarjeto?.edad = responseData['user']['perfil']['datosPersonales']['edad'];
            clienteTarjeto?.genero = responseData['user']['perfil']['datosPersonales']['genero'];
            clienteTarjeto?.fotoPerfil = responseData['user']['perfil']['datosPersonales']['fotoPerfil'];
            clienteTarjeto?.ciudad = responseData['user']['perfil']['datosPersonales']['ubicacion']['ciudad'];
            clienteTarjeto?.codigoPostal = responseData['user']['perfil']['datosPersonales']['ubicacion']['codigoPostal'];
            clienteTarjeto?.categoriasFavoritas = responseData['user']['perfil']['categoriaFavorita'];
            clienteTarjeto?.tarjetas = responseData['user']['perfil']['tarjetas'];
            clienteTarjeto?.publicID = responseData['user']['perfil']['publicID'];
            print(clienteTarjeto.toString());




            Navigator.pushNamed(context, '/navigationbarprincipal');
          } else {
            setState(() {
              _errorMessage = jsonDecode(newResponse.body)['message'] ?? "Error desconocido.";
            });
          }
        }
      } else if (response.statusCode == 200) {
        final responseData = jsonDecode(await response.stream.bytesToString());
        print("Login exitoso: ${responseData}");
        Navigator.pushNamed(context, '/navigationbarprincipal');
      } else {
        setState(() {
          _errorMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _errorMessage = "Error de conexión. Intenta de nuevo.";
      });
    }
  }

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
                                   controller: _emailController,
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
                                  controller: _passwordController,
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

                              if (_errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
                                          _login();
                                         //Navigator.pushNamed(context, '/navigationbarprincipal');
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

