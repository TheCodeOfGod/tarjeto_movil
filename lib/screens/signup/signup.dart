import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:tarjeto/utilis/cliente_tarjeto.dart';
import 'package:tarjeto/utilis/cliente_tarjeto_storage.dart';

import '../../config/config.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  //Objeto para el storage
  final ClienteTarjetoStorage storage = ClienteTarjetoStorage();


  //Controladores de inputs
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _correoController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  //funcion para consultar la api de signup
  Future<void> _signup() async {
    final String apiUrl = "https://api.tarjeto.app/api/auth/signup";
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cliente': 'flutter-app',
    };

    final Map<String, String> body = {
      'email': _correoController.text,
      'contrasena': _passwordController.text,
      'nombre': _nombreController.text
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
          print("Entro a response.statusCoce = 307");
          print("Redirigiendo a: $newUrl");

          // vuelve a hacer la petición
          final newResponse = await http.post(
            Uri.parse(newUrl),
            headers: headers,
            body: jsonEncode(body),
          );
          
          print("newRespose.statusCode: ${newResponse.statusCode}");
          print("response.statusCode = ${response.statusCode}");

          if (newResponse.statusCode == 201) {   //Si el status del nuevo response es igual a 201 quiere decir que se creo el usuario y nos devuele un json con los datos del usuario
            final Map<String, dynamic> responseData = jsonDecode(newResponse.body);
            print("API EXITOSA newResponse.statusCode == 200");
            print("Login exitoso: ${responseData}");

            ClienteTarjeto? cliente = await storage.getCliente();
            cliente?.nombre = responseData['user']['nombre'];
            cliente?.email = responseData['user']['email'];
            cliente?.verificado = responseData['user']['verificado'];
            cliente?.pantalla = "/verificarcorreo"; //guarda la pantalla que se quedara
            await storage.saveCliente(cliente!);


            Navigator.pushNamed(context, '/verificarcorreo'); // Redirige si es exitoso a la siguiente pantalla
          } else {
            setState(() {
              _errorMessage = jsonDecode(newResponse.body)['message'] ?? "Error desconocido.";
            });
          }
        }
      } else if (response.statusCode == 201) {  //Si entra desde el primer response se ejecuta este si no se va a ejecutar el newResponse
        final responseData = jsonDecode(await response.stream.bytesToString());
        print("API EXITOSA response.statusCode == 200");
        print("Login exitoso: ${responseData}");
        Navigator.pushNamed(context, '/verificarcorreo'); // Redirige si es exitoso a la siguiente pantalla
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
                    child: SingleChildScrollView(
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
                           Padding(
                              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
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
                                        controller: _nombreController,
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
                                        controller: _correoController,
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
                                        controller: _passwordController,
                                        cursorColor: TarjetoColors.fieldOutline,
                                        obscureText: true,
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

                                    if (_errorMessage != null)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                          _errorMessage!,
                                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
                                                _signup();
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('¿Ya tienes cuenta? ¡Inicia sesión ',style: TarjetoTextStyle.chicoTextColorBold,),
                                          GestureDetector(child: Text('aqui!', style: TarjetoTextStyle.chicoRojoBold,), onTap: () {
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
                      
                        ],
                      ),
                    ),
                  )
              )
            ],
          )),
    );
  }
}
