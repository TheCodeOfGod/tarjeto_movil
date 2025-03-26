import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:tarjeto/utilis/cliente_tarjeto.dart';
import 'package:tarjeto/utilis/cliente_tarjeto_storage.dart';

import '../../config/config.dart';

class SubirCategorias extends StatefulWidget {
  const SubirCategorias({Key? key}) : super(key: key);

  @override
  _SubirCategoriasState createState() => _SubirCategoriasState();
}

class _SubirCategoriasState extends State<SubirCategorias> {
  final ClienteTarjetoStorage storage = ClienteTarjetoStorage();

  final List<Map<String, String>> categorias = [
    {"id": "cafeteria", "nombre": "Cafetería", "icono": TarjetoImages.cafeteria_icono},
    {"id": "panaderia", "nombre": "Panadería", "icono": TarjetoImages.panaderia_icono},
    {"id": "pizzeria", "nombre": "Pizzería", "icono": TarjetoImages.pizzeria_icono},
    {"id": "comida-rapida", "nombre": "Rápida", "icono": TarjetoImages.rapida_icon},
    {"id": "taqueria", "nombre": "Taquería", "icono": TarjetoImages.tacos_icono},
    {"id": "buffet", "nombre": "Buffet", "icono": TarjetoImages.buffet_icono},
    {"id": "comida-saludable", "nombre": "Saludable", "icono": TarjetoImages.saludable_icono},
    {"id": "mariscos", "nombre": "Mariscos", "icono": TarjetoImages.mariscos_icono}
  ];

  Set<String> categoriasSeleccionadas = {};

  bool _selectOne = false;


  Future<void> _subirCategorias2() async{
    ClienteTarjeto? clienteTarjeto = await storage.getCliente();

    List<String> categoriasSeleccionadasALista = categoriasSeleccionadas.toList();
    
    // IMPRIMIR AQUI categoriasSeleccionadasALista
    print('Categorías seleccionadas: $categoriasSeleccionadasALista');

    clienteTarjeto?.categoriasFavoritas = categoriasSeleccionadasALista;

  }



  Future<void> _subirCategorias() async {
    ClienteTarjeto? clienteTarjeto = await storage.getCliente();

    List<String> categoriasSeleccionadasALista = categoriasSeleccionadas.toList();

    // IMPRIMIR CATEGORÍAS SELECCIONADAS
    print('Categorías seleccionadas: $categoriasSeleccionadasALista');

    clienteTarjeto?.categoriasFavoritas = categoriasSeleccionadasALista;

    // Configuración de la API
    final String apiUrl = "https://api.tarjeto.app/api/auth/setup-profile";
    final String token = clienteTarjeto!.token!;

    final Map<String, String> headers = {
      "Accept": "application/json",
      "Cliente": "flutter-app",
      "Authorization": "Bearer $token"
    };

    // Datos en formato JSON
    final String profileData = jsonEncode({
      "datosPersonales": {
        "nombre": clienteTarjeto.nombre,
        "edad": clienteTarjeto.edad,
        "genero": clienteTarjeto.genero,
        "fotoPerfil": clienteTarjeto.fotoPerfil,
        "ubicacion": {
          "ciudad": clienteTarjeto.ciudad,
          "codigoPostal": ""
        }
      },
      "categoriaFavorita": clienteTarjeto.categoriasFavoritas,
      "engagement": {
        "ultimoLogin": "",
        "sesionesTotal": 0,
        "tiempoPromedioSesion": 0,
        "dispositivosUsados": []
      },
      "valorCliente": {
        "ltv": 0,
        "churnRisk": 0,
        "segmento": "nuevo",
        "referidos": []
      }
    });

    final http.Client client = http.Client();

    try {
      // Primera solicitud
      final http.Request request = http.Request("POST", Uri.parse(apiUrl))
        ..headers.addAll(headers)
        ..bodyFields = {
          "userType": "user",
          "profileData": profileData,
        };

      final http.StreamedResponse response = await client.send(request);

      if (response.statusCode == 307) {
        // Manejo de redirección
        final String? newUrl = response.headers['location'];
        if (newUrl != null) {
          print("Redirigiendo a: $newUrl");

          // Segunda solicitud asegurando que se envíe como form-data
          var requestRedirect = http.MultipartRequest("POST", Uri.parse(newUrl))
            ..headers.addAll(headers)
            ..fields["userType"] = "user"
            ..fields["profileData"] = profileData;

          final http.StreamedResponse newResponse = await requestRedirect.send();
          final String responseBody = await newResponse.stream.bytesToString();

          if (newResponse.statusCode == 200) {
            print("Categorías subidas correctamente.");
          } else {
            print("Error en la respuesta: $responseBody");
          }
        }
      } else if (response.statusCode == 200) {
        final responseData = jsonDecode(await response.stream.bytesToString());
        print("Categorías subidas correctamente: $responseData");
      } else {
        print("Error al subir categorías: ${response.statusCode}");
      }
    } catch (e) {
      print("Error de conexión: $e");
    } finally {
      client.close();
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
                        'Ahora dinos, ¿qué buscas en tarjeto?',
                        style: TarjetoTextStyle.grandeTextColorMedium,
                      ),
                    ),

                    //Container gris principal
                    Container(
                      margin: const EdgeInsets.all(25),
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
                            Row(
                              children: [
                                Text(
                                  'Categorías',
                                  style: TarjetoTextStyle.medianoRojoBold,
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                              child: Text('Selecciona tus categorías favoritas', style: TarjetoTextStyle.medianoTextColorMedium,),
                            ),


                            // Grid de categorías
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 columnas
                                childAspectRatio: 3, // Ajusta la proporción
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: categorias.length,
                              itemBuilder: (context, index) {
                                String id = categorias[index]["id"]!;
                                String nombre = categorias[index]["nombre"]!;
                                String icono = categorias[index]["icono"]!;
                                bool isSelected = categoriasSeleccionadas.contains(id);

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        categoriasSeleccionadas.remove(id);

                                      } else {
                                        categoriasSeleccionadas.add(id);
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected ? TarjetoColors.rojoPrincipal : TarjetoColors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: TarjetoColors.rojoPrincipal),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(icono, width: 20, height: 20, color: isSelected ? Colors.white : TarjetoColors.rojoPrincipal),
                                        SizedBox(width: 8),
                                        Text(
                                          nombre,
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : TarjetoColors.rojoPrincipal,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
                          backgroundColor: _selectOne ? TarjetoColors.rojoPrincipal : TarjetoColors.fieldBackground,
                          foregroundColor: TarjetoColors.fieldOutline,
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),

                          ),
                          elevation: 0,
                        ),
                        onPressed: (){
                          _subirCategorias();

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                            "Continuar",
                              style: _selectOne ? TarjetoTextStyle.btnTextBlanco : TarjetoTextStyle.btnTextTextColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: SvgPicture.asset(_selectOne ?  TarjetoImages.flechaDerechaIcon : TarjetoImages.flechaDerechaIconTextColor,
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
