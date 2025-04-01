import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tarjeto/screens/navegationbar/widgets/tarjeta_card.dart';
import 'package:tarjeto/utilis/cliente_tarjeto_storage.dart';

import '../../../config/config.dart';
import '../../../utilis/cliente_tarjeto.dart';
import '../../../utilis/promocion.dart';
import '../../../utilis/tarjeta.dart';

class ExpandirTarjeta extends StatefulWidget{
  final TarjetaTarjeto tarjeta;
  const ExpandirTarjeta({Key? key,  required this.tarjeta}) : super(key: key);

  @override
  _ExpandirTarjetaState createState() => _ExpandirTarjetaState();
}

class _ExpandirTarjetaState extends State<ExpandirTarjeta> {
  final ClienteTarjetoStorage storage = ClienteTarjetoStorage();
  ClienteTarjeto? clienteTarjeto;
  late String nombreNegocio;

  List<Promocion> _promociones =[];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nombreNegocio = widget.tarjeta.negocioNombre!;
    obtenerPromociones().then((_){
      filtrarPromocionesDelNegocio(_promociones);
    });
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

  void filtrarPromocionesDelNegocio(List<Promocion> todasLasPromociones) {
    final String nombreDelNegocioActual = widget.tarjeta.negocioNombre ?? '';

    List<Promocion> filtradas = todasLasPromociones.where((promo) {
      return promo.negocio?.toLowerCase().trim() == nombreDelNegocioActual.toLowerCase().trim();
    }).toList();

    setState(() {
      _promociones = filtradas;
    });

    print("Promociones filtradas: ${_promociones.length} para $nombreDelNegocioActual");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TarjetoColors.rojoPrincipal,
      body: SafeArea(
          child: Container(
            color: TarjetoColors.white,
            height: double.infinity,
            child: Padding(
                padding: EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("$nombreNegocio", style: TarjetoTextStyle.grandeRojoBold,)
                      ],
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: TarjetaCard(
                            tarjeta: widget.tarjeta
                        )
                    ),

                    //Lista de promociones del negocio
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
                            "Este negocio aún no tiene promociones activas.",
                            style: TarjetoTextStyle.chicoTextColorMedium,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
