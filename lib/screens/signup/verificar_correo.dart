import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tarjeto/config/config.dart';

class VerificarCorreo extends StatefulWidget {
  const VerificarCorreo({Key? key}) : super(key: key);

  @override
  _VerificarCorreoState createState() => _VerificarCorreoState();
}

class _VerificarCorreoState extends State<VerificarCorreo> {
  TextEditingController _pinController = TextEditingController();

  bool _progres = false;

  String? _errorMessage;

  //bandera para saber si esta lleno el pin
  bool isPinComplete = false;

  //funcion para cambiar la bandera del pin si ya se llenaron los 6
  void _onPinChanged(String value) {
    setState(() {
      isPinComplete = value.length == 6; // si la longitud de value es igual a 6 se cambia la bandera a verdadero
    });
  }

  Future<void> _verificarCodigo() async {
    final String apiUrl = "https://api.tarjeto.app/api/auth/verify-email";
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cliente': 'flutter-app',
    };

    final Map<String, String> body = {
      'code': _pinController.text,
    };
    
    print(_pinController.text);

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

          if (newResponse.statusCode == 200) {   //Si el status del nuevo response es igual a 200 quiere decir que se verifico el correo
            final Map<String, dynamic> responseData = jsonDecode(newResponse.body);
            print("API EXITOSA newResponse.statusCode == 200");
            print("Login exitoso: ${responseData}");
            setState(() {
              _errorMessage = "Usuario ${jsonDecode(newResponse.body)['user']['nombre']} verificado";
              _progres = true;
            });
            Navigator.pushNamed(context, '/subirfotoperfil'); // Redirige si es exitoso a la siguiente pantalla
          } else {
            setState(() {
              _errorMessage = jsonDecode(newResponse.body)['message'] ?? "Error desconocido.";
            });
          }
        }
      } else if (response.statusCode == 200) {  //Si entra desde el primer response se ejecuta este si no se va a ejecutar el newResponse
        final responseData = jsonDecode(await response.stream.bytesToString());
        print("API EXITOSA response.statusCode == 200");
        print("Login exitoso: ${responseData}");
        //Navigator.pushNamed(context, '/verificarcorreo'); // Redirige si es exitoso a la siguiente pantalla
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
            
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 40, 5, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: PinCodeTextField(
                            controller: _pinController,
                            keyboardType: TextInputType.number,
                            appContext: context,
                            length: 6,
                            textStyle: TarjetoTextStyle.placeholderRojoInput,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              inactiveColor: TarjetoColors.fieldOutline,
                              activeColor: TarjetoColors.rojoHover,
                              inactiveFillColor: TarjetoColors.fieldBackground,
                              activeFillColor: TarjetoColors.rojoHover,
                              selectedColor: TarjetoColors.rojoHover,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onChanged: _onPinChanged,
                          )
                        ),
                      ],
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

                // Botón siguiente
                Container(
                  margin: const EdgeInsets.fromLTRB(25, 40, 25, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPinComplete ? TarjetoColors.rojoPrincipal : TarjetoColors.white,
                      foregroundColor: TarjetoColors.fieldOutline,
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isPinComplete ? () {
                      _verificarCodigo(); // Acción cuando el código está completo
                    } : null, // Desactiva el botón si no está completo
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Siguiente",
                          style: isPinComplete ? TarjetoTextStyle.btnTextBlanco : TarjetoTextStyle.btnTextTextColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: SvgPicture.asset(isPinComplete ? TarjetoImages.flechaDerechaIcon : TarjetoImages.flechaDerechaIconTextColor ,
                            width: 20,
                            height: 20,),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(25, 80, 25, 0),
                  decoration: BoxDecoration(
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
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
                        flex: _progres ? 0 : 1, //con la bandera _progres sabemos si se verifico y avanza la barra de progreso
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
        )
      ),


    );
  }
}
