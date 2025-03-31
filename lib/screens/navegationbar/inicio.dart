import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:tarjeto/utilis/cliente_tarjeto.dart';
import 'package:tarjeto/utilis/cliente_tarjeto_storage.dart';
import 'package:tarjeto/utilis/tarjeta.dart';
import '../../config/config.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../utilis/promocion.dart';

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

  TarjetaTarjeto? tarjetaFavorita;

  List<TarjetaTarjeto>? listaTarjetas;


  final List<Promocion> _promociones = [
    Promocion(
      negocio: 'Joyería Perlita',
      titulo: 'Promociones',
      descripcion: 'Recibe 30% de descuento en tu primer collar de acero inoxidable.',
      nivelRequerido: 'Nivel 1'
    ),
    Promocion(
        negocio: 'Caffe Corinto',
        titulo: 'Oferta',
        descripcion: 'Recibe 20% de descuento en tu segundo cafe.',
        nivelRequerido: 'Nivel 2'
    ),
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cargarStorage();
    _obtenerTarjetas();
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

  Future<void> _obtenerTarjetas() async {
    ClienteTarjeto? clienteTarjeto = await storage.getCliente();

    if (clienteTarjeto == null || clienteTarjeto.token == null) {
      print("Error: Cliente o token no disponible.");
      return;
    }

    final String apiUrl = "https://api.tarjeto.app/api/cliente/tarjetas";
    final String token = clienteTarjeto.token!;

    final Map<String, String> headers = {
      "mobile-auth": "Bearer $token",
      "Cliente": "flutter"
    };

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["success"] == true) {
          List<dynamic> tarjetasData = responseData["data"]["tarjetas"];

          setState(() {
            listaTarjetas = tarjetasData.map((tarjeta) {
              return TarjetaTarjeto(
                negocioId: tarjeta["negocio_id"],
                nivel: tarjeta["nivel"],
                visitas: tarjeta["visitas"],
                ultimaVisita: DateTime.tryParse(tarjeta["ultimaVisita"]),
                rachaVisitasConsecutivas: tarjeta["rachaVisitasConsecutivas"],
                maximaRachaLograda: tarjeta["maximaRachaLograda"],
                idTarjeta: tarjeta["_id"],
                negocioNombre: tarjeta["negocio_nombre"],
                nivelNombre: tarjeta["nivel_nombre"],
                visitasProximoNivel: tarjeta["visitas_proximo_nivel"],
                proximoNivel: tarjeta["proximo_nivel"],
                beneficios: List<String>.from(tarjeta["beneficios"]),
                temporadaFin: DateTime.tryParse(tarjeta["temporada_fin"]),
              );
            }).toList();

            // Buscar y asignar la tarjeta con más visitas
            if (listaTarjetas!.isNotEmpty) {
              tarjetaFavorita = listaTarjetas!.reduce((a, b) {
                int visitasA = a.visitas ?? 0;
                int visitasB = b.visitas ?? 0;
                return visitasA >= visitasB ? a : b;
              });
            }
          });

          print("Tarjetas obtenidas correctamente (${listaTarjetas!.length} tarjetas).");
          print("Tarjeta favorita: ${tarjetaFavorita?.negocioNombre} con ${tarjetaFavorita?.visitas} visitas.");
        } else {
          print("Error en la API: ${responseData["message"]}");
        }
      } else {
        print("Error al obtener tarjetas: Código ${response.statusCode}");
      }
    } catch (e) {
      print("Error de conexión: $e");
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
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                      ),

                      //Spacer para el icono de tarjeto a la derecha
                      Spacer(),
                      SvgPicture.asset(TarjetoImages.logoCorazonRojo, height: 32,)
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(8, 30, 0, 0),
                      child: Row(
                        children: [
                          Text('Sección de ofertas', style: TarjetoTextStyle.medianoTextColorBold,),
                        ],
                      )
                  ),

                  //Carrusel de promociones
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: TarjetoColors.fieldBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 150, // Mantenemos la altura fija como estaba originalmente
                          autoPlay: true,
                          viewportFraction: 1.0, // Cambiamos a 1.0 para que ocupe todo el ancho
                          autoPlayInterval: Duration(seconds: 6),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                        ),
                        items: _promociones.map((promocion) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                width: MediaQuery.of(context).size.width, // Usa todo el ancho disponible
                                margin: EdgeInsets.symmetric(horizontal: 17.0, vertical: 17.0), // Reducimos el margen horizontal
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  //border: Border.all(color: TarjetoColors.rojoPrincipal, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: TarjetoColors.black.withOpacity(0.15),
                                      blurRadius:8, // Desenfoque
                                      spreadRadius: 0.2, // Expansión de la sombra
                                      offset: Offset(0, 0), // Dirección (X, Y)
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            promocion.negocio!,
                                            style: TarjetoTextStyle.normalTextColorBold,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            promocion.descripcion!,
                                            style: TarjetoTextStyle.chicoTextColorMedium,
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: TarjetoColors.rojoPrincipal,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Text(
                                              promocion.nivelRequerido!,
                                              style: TextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Tu tarjeta favorita (La que tenga mas visitas)
                  Container(
                      margin: EdgeInsets.fromLTRB(8, 20, 0, 0),
                      child: Row(
                        children: [
                          Text('Tu tarjeta favorita:', style: TarjetoTextStyle.medianoTextColorBold,),
                        ],
                      )
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    height: 230,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: TarjetoGradient.oroCardBackground,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: tarjetaFavorita == null
                        ? Center(child: CircularProgressIndicator( color: TarjetoColors.rojoHover,))
                        : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  tarjetaFavorita!.negocioNombre ?? 'Nombre no disponible',
                                  style: TarjetoTextStyle.grandeBlancoMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(25, 15, 0, 15),
                          decoration: BoxDecoration(
                            gradient: TarjetoGradient.oroCardFooter,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(TarjetoImages.logoBlancoConLetras, height: 20),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text('•', style: TarjetoTextStyle.normalBlancoMedium),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(
                                  tarjetaFavorita!.nivelNombre != null
                                      ? 'Nivel ${tarjetaFavorita!.nivelNombre}'
                                      : 'Sin nivel',
                                  style: TarjetoTextStyle.normalBlancoMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),





                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
