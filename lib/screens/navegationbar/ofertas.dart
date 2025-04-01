import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:tarjeto/config/config.dart';
import 'package:tarjeto/utilis/promocion.dart';

import '../../utilis/cliente_tarjeto.dart';
import '../../utilis/cliente_tarjeto_storage.dart';

class Ofertas extends StatefulWidget {
  const Ofertas({Key? key}) : super(key: key);

  @override
  _OfertasState createState() => _OfertasState();
}

class _OfertasState extends State<Ofertas> {
  final ClienteTarjetoStorage storage = ClienteTarjetoStorage();
  ClienteTarjeto? clienteTarjeto;
  late String nombreNegocio;
  List<Promocion> _promociones = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      obtenerPromociones();
  }

  Future<void> _cargarStorage() async{
    ClienteTarjeto? cliente = await storage.getCliente();
    setState(() {
      clienteTarjeto = cliente;
    });
  }

  Future<void> obtenerPromociones() async {
    await _cargarStorage();
    if (clienteTarjeto == null || clienteTarjeto!.token == null) {
      print("Error: Cliente o token no disponible.");
      return;
    }

    final String apiUrl = "https://api.tarjeto.app/api/cliente/promociones";
    final String token = clienteTarjeto!.token!;

    final Map<String, String> headers = {
      "Cliente": "flutter",
      "mobile-auth": "Bearer $token",
      "Accept": "application/json"
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["success"] == true) {
          List<dynamic> programa = responseData["data"]["programa"];

          List<Promocion> nuevasPromociones = programa.map((promo) {
            return Promocion(
              negocio: promo["negocioNombre"],
              titulo: promo["titulo"],
              descripcion: promo["descripcion"],
              nivelRequerido: "Nivel ${promo["nivelReq"]}",
            );
          }).toList();

          setState(() {
            _promociones.clear();
            _promociones.addAll(nuevasPromociones);
          });

          print("Promociones actualizadas correctamente (${_promociones.length}).");
        } else {
          print("Error desde la API: ${responseData["message"]}");
        }
      } else {
        print("Error al consultar promociones: Código ${response.statusCode}");
      }
    } catch (e) {
      print("Error de conexión en obtenerPromociones: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TarjetoColors.rojoPrincipal,
      body: SafeArea(
          child:
          Container(
            color: TarjetoColors.white,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 9.5, 0, 0),
                    child: Row(
                      children: [
                        Text('Tus ofertas', style: TarjetoTextStyle.tituloTextColorBold,),
                        Spacer(),
                        SvgPicture.asset(TarjetoImages.logoCorazonRojo, height: 32,),
                      ],
                    ),
                  ),

                  // Lista de promociones
                  if (_promociones.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 25),
                        Text(
                          "Promociones disponibles",
                          style: TarjetoTextStyle.medianoTextColorBold,
                        ),
                        SizedBox(height: 15),
                        ..._promociones.map((promo) {
                          return Container(
                            width: double.infinity, // 👈 Asegura el ancho máximo
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: TarjetoColors.fieldBackground,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: TarjetoColors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  promo.titulo ?? 'Sin título',
                                  style: TarjetoTextStyle.normalTextColorBold,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  promo.descripcion ?? 'Sin descripción',
                                  style: TarjetoTextStyle.chicoTextColorMedium,
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: TarjetoColors.rojoPrincipal,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    promo.nivelRequerido ?? '',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                        child: Text(
                          "Aún no tienes ofertas disponibles.",
                          style: TarjetoTextStyle.medianoTextColorMedium,
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
